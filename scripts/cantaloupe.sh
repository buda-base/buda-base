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
export DOWNLOADS=$DATA_DIR/JettyDownloads
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
export CANTALOUPE=cantaloupe
export CANTALOUPE_HOST=localhost
export CANTALOUPE_PORT=13380
export CANTALOUPE_HOME=$DATA_DIR/$CANTALOUPE/jetty
export CANTALOUPE_WEBAPPS=$CANTALOUPE_HOME/webapps
export CANTALOUPE_GIT=$DATA_DIR/downloads/cantaloupe-bdrc

#***********************************************************
# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
useradd -s /bin/bash -g $TC_GROUP -d $CANTALOUPE_HOME $TC_USER


# install jetty container
# jetty should have been downloaded by fuseki.sh
echo ">>>> installing jetty 9 for cantaloupe"

mkdir $DOWNLOADS
mkdir $DATA_DIR/$CANTALOUPE
mkdir $CANTALOUPE_HOME

cd $DOWNLOADS
wget -q -c "http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.8.v20171121/jetty-distribution-9.4.8.v20171121.tar.gz"
tar xf $DOWNLOADS/jetty-distribution-9*tar.gz -C $CANTALOUPE_HOME --strip-components=1

# configure server
echo ">>>> configuring jetty 9 for deployment"
erb /vagrant/conf/jetty/cantaloupe-app.xml.erb > $CANTALOUPE_WEBAPPS/cantaloupe-app.xml

git clone https://github.com/BuddhistDigitalResourceCenter/cantaloupe-bdrc.git
cd $CANTALOUPE_GIT
mvn compile
mvn war:war
mv $CANTALOUPE_GIT/target/Cantaloupe*.war $CANTALOUPE_HOME/cantaloupe.war

erb /vagrant/conf/jetty/startup.sh.erb > $CANTALOUPE_HOME/startup.sh
erb /vagrant/conf/jetty/shutdown.sh.erb > $CANTALOUPE_HOME/shutdown.sh

echo ">>>> fixing permissions"
chown -R $USER:$USER $DOWNLOADS
chown -R $TC_USER:$TC_GROUP $CANTALOUPE_HOME

# setup as Debian systemctl service listening on 9099
echo ">>>> setting up ${CANTALOUPE} as service listening on 9099"
erb /vagrant/conf/jetty/systemd.erb > /etc/systemd/system/$LDSPDI.service

rm -r $DOWNLOADS

echo ">>>> starting ${CANTALOUPE} service"
systemctl daemon-reload
systemctl enable $CANTALOUPE
systemctl start $CANTALOUPE &
