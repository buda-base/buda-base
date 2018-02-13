#!/usr/bin/env bash

echo ">>>> Installing cantaloupe IIIF server..."
export SVC_DESC="BUDA Image Service - IIIF compliant"
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
export CANTALOUPE_HOST=localhost
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
mkdir $DATA_DIR/$CANTALOUPE
mkdir $CANTALOUPE_HOME

# Installing gem
echo ">>>> Installing gem..."
apt-get install gem

echo ">>>> Installing dalli gem..."
gem install --install-dir $GEM_HOME dalli

cd $DOWNLOADS
wget "http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.8.v20171121/jetty-distribution-9.4.8.v20171121.tar.gz"
tar xf $DOWNLOADS/jetty-distribution-9*tar.gz -C $CANTALOUPE_HOME --strip-components=1

# configure server
echo ">>>> configuring jetty 9 for deployment"
erb /vagrant/conf/jetty/cantaloupe-app.xml.erb > $CANTALOUPE_WEBAPPS/cantaloupe-app.xml

echo ">>>> getting Cantaloupe-3.7.1..."
wget 'https://github.com/medusa-project/cantaloupe/releases/download/v3.4.1/Cantaloupe-3.4.1.zip'
unzip Cantaloupe-3.4.1.zip
mv $DOWNLOADS/Cantaloupe-3.4.1.war $CANTALOUPE_HOME/cantaloupe.war

echo ">>>> getting Cantaloupe script..."
wget 'https://raw.githubusercontent.com/BuddhistDigitalResourceCenter/cantaloupe-scripts/master/ruby/delegates.rb'
cp delegates.rb $CANTALOUPE_HOME
erb /vagrant/conf/jetty/startup.sh.erb > $CANTALOUPE_HOME/startup.sh
erb /vagrant/conf/jetty/shutdown.sh.erb > $CANTALOUPE_HOME/shutdown.sh


echo ">>>> fixing permissions"
chown -R $USER:$USER $DOWNLOADS
chown -R $TC_USER:$TC_GROUP $CANTALOUPE_HOME

# setup as Debian systemctl service listening on 9099
echo ">>>> setting up ${CANTALOUPE} as service listening on 9099"
erb /vagrant/conf/jetty/systemd.erb > /etc/systemd/system/$CANTALOUPE.service
rm -r $DOWNLOADS

echo ">>>> starting ${CANTALOUPE} service"
systemctl daemon-reload
systemctl enable $CANTALOUPE
systemctl start $CANTALOUPE &
