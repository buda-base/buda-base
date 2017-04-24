#!/usr/bin/env bash

#general vars
echo ">>>> Installing Fuseki"
export DOWNLOADS=/usr/local/downloads
export TC_USER=fuseki
export TC_GROUP=fuseki
# set erb vars
export SVC=fuseki
export SVC_DESC="Jena-Fuseki Tomcat container"
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
export FUSEKI_REL="https://github.com/BuddhistDigitalResourceCenter/jena/releases/download/vfuseki_2.6.0/apache-jena-fuseki-2.6.0-SNAPSHOT.tar.gz"
export FUSEKI_TAR="apache-jena-fuseki-2.6.0-SNAPSHOT.tar.gz"
export THE_HOME=/usr/local/$SVC
export CAT_HOME=$THE_HOME/tomcat
export SHUTDOWN_PORT=13105
export MAIN_PORT=13180
export REDIR_PORT=13143
export AJP_PORT=13109
export MAX_MEM="-Xmx4096M"

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER

# place to download non apt-get items
mkdir -p $DOWNLOADS

# install tomcat container
# download tomcat
echo ">>>> downloading tomcat 8"
pushd $DOWNLOADS;
wget -q -c http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.42/bin/apache-tomcat-8.0.42.tar.gz
# unpack tomcat
echo ">>>> unpacking tomcat 8"
mkdir -p $CAT_HOME
tar xf $DOWNLOADS/apache-tomcat-8*tar.gz -C $CAT_HOME --strip-components=1
# configure server
echo ">>>> configuring server.xml tomcat 8"
erb /vagrant/conf/tomcat/server.xml.erb > $CAT_HOME/conf/server.xml
# enable tomcat admin and manager apps
cp  /vagrant/conf/tomcat/tomcat-users.xml $CAT_HOME/conf/
popd

# download fuseki
echo ">>>> downloading jena-fuseki 2.5.0"
pushd $DOWNLOADS;
wget -q -c $FUSEKI_REL
tar xf $FUSEKI_TAR
echo ">>>> copying fuseki war to tomcat container"
# until new war is released copy locally updated war with log4j - JENA-1185
# cp /vagrant/lib/jena-fuseki-war-2.4.0.war $CAT_HOME/webapps/fuseki.war
cp apache-jena-fuseki-2.5.0/fuseki.war $CAT_HOME/webapps
popd

echo ">>>> configuring FUSEKI_BASE"
mkdir -p $THE_HOME/base
ln -s $THE_HOME/base /etc/fuseki
# fix permissions
echo ">>>> fixing permissions"
chown -R $USER:$USER $DOWNLOADS
chown -R $TC_USER:$TC_GROUP $THE_HOME

pushd $CAT_HOME
# chgrp -R $TC_USER conf webapps
chmod g+rwx conf webapps
chmod g+r conf/*
# chown -R $TC_USER work/ temp/ logs/ webapps/
popd

# setup as Debian systemctl service listening on $MAIN_PORT
echo ">>>> setting up ${SVC} as service"
erb /vagrant/conf/tomcat/systemd.erb > /etc/systemd/system/$SVC.service
echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
# wait for couchdb to finish initializing $THE_HOME/base/
sleep 5
systemctl stop $SVC
echo ">>>> updating ${SVC} configuration"
# update configuration and restart
mkdir -p $THE_HOME/base/configuration
cp /vagrant/conf/fuseki/shiro.ini $THE_HOME/base/
export EP_NAME=bdrc
erb /vagrant/conf/fuseki/ttl.erb > $THE_HOME/base/configuration/bdrc.ttl
export EP_NAME=test
erb /vagrant/conf/fuseki/ttl.erb > $THE_HOME/base/configuration/test.ttl
cp /vagrant/conf/fuseki/qonsole-config.js $THE_HOME/tomcat/webapps/fuseki/js/app/
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"
