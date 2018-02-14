#!/usr/bin/env bash

echo ">>>> Installing cantaloupe IIIF server..."
export SVC_DESC="Cantaloupe"
export TC_USER=cantaloupe
export TC_GROUP=cantaloupe

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ;
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
export GEM_HOME=$DATA_DIR/ruby
export CANTALOUPE=cantaloupe
export CANTALOUPE_HOME=$DATA_DIR/$CANTALOUPE/jetty
export CANTALOUPE_WEBAPPS=$CANTALOUPE_HOME/webapps
export CANTALOUPE_GIT=$DATA_DIR/downloads/cantaloupe-bdrc

#***********************************************************
# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
useradd -s /bin/bash -g $TC_GROUP -d $CANTALOUPE_HOME $TC_USER


# install jetty container
echo ">>>> installing jetty 9 for cantaloupe"

mkdir $DOWNLOADS
mkdir -p $DATA_DIR/$CANTALOUPE
mkdir -p $CANTALOUPE_HOME


if [ $(dpkg-query -W -f='${Status}' gem 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	apt-get install gem memcached -y
fi

echo ">>>> Installing gems"
gem install --install-dir $GEM_HOME dalli

pushd $DOWNLOADS
wget -q -c "http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.8.v20171121/jetty-distribution-9.4.8.v20171121.tar.gz"
tar xf jetty-distribution-9.4.8.v20171121.tar.gz -C $CANTALOUPE_HOME --strip-components=1

# configure server
echo ">>>> configuring jetty 9 for deployment"
erb /vagrant/conf/cantaloupe/cantaloupe-app.xml.erb > $CANTALOUPE_WEBAPPS/cantaloupe-app.xml

echo ">>>> getting Cantaloupe..."
wget -q -c 'https://github.com/medusa-project/cantaloupe/releases/download/v3.4.1/Cantaloupe-3.4.1.zip'
unzip Cantaloupe-3.4.1.zip
mv Cantaloupe-3.4.1/Cantaloupe-3.4.1.war $CANTALOUPE_HOME/cantaloupe.war
popd

echo ">>>> getting Cantaloupe script..."

cp /vagrant/conf/cantaloupe/delegates.rb $CANTALOUPE_HOME
erb /vagrant/conf/cantaloupe/startup.sh.erb > $CANTALOUPE_HOME/startup.sh
erb /vagrant/conf/cantaloupe/shutdown.sh.erb > $CANTALOUPE_HOME/shutdown.sh

echo ">>>> fixing permissions"
chown -R $USER:$USER $DOWNLOADS
chown -R $TC_USER:$TC_GROUP $CANTALOUPE_HOME

# setup as Debian systemctl service listening on 9099
echo ">>>> setting up ${CANTALOUPE} as service listening on 9099"
erb /vagrant/conf/cantaloupe/systemd.erb > /etc/systemd/system/$CANTALOUPE.service

echo ">>>> starting ${CANTALOUPE} service"
systemctl daemon-reload
systemctl enable $CANTALOUPE
systemctl start $CANTALOUPE