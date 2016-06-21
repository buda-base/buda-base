#!/usr/bin/env bash

#general vars
echo ">>>> home: ${HOME}"
export DOWNLOADS=$HOME/downloads
export TC_USER=fuseki
export TC_GROUP=fuseki
# set erb vars
export SVC=fuseki
export SVC_DESC="Jena-Fuseki Tomcat container"
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
export THE_HOME=/usr/local/$SVC
export CAT_HOME=$THE_HOME/tomcat
export SHUTDOWN_PORT=13105
export MAIN_PORT=13180
export REDIR_PORT=13143
export AJP_PORT=13109
# install tomcat container
# add USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# place to download non apt-get items
mkdir -p $DOWNLOADS
# download tomcat
echo ">>>> downloading tomcat 8"
pushd $DOWNLOADS;
wget http://download.nextag.com/apache/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz
popd
mkdir -p $CAT_HOME
# unpack tomcat
echo ">>>> unpacking tomcat 8"
tar xf $DOWNLOADS/apache-tomcat-8*tar.gz -C $CAT_HOME --strip-components=1
# configure server
echo ">>>> configuring server.xml tomcat 8"
erb /vagrant/conf/tomcat/server.xml.erb > $CAT_HOME/conf/server.xml
# enable tomcat admin and manager apps
cp  /vagrant/conf/tomcat/tomcat-users.xml $CAT_HOME/conf/
# download fuseki
echo ">>>> downloading jena-fuseki 2.4.0"
pushd $DOWNLOADS;
wget http://supergsego.com/apache/jena/binaries/apache-jena-fuseki-2.4.0.tar.gz
tar xf apache-jena-fuseki-2.4.0.tar.gz
echo ">>>> copying fuseki war to tomcat container"
# until new war is released copy locally updated war with log4j - JENA-1185
# cp apache-jena-fuseki-2.4.0/fuseki.war $CAT_HOME/webapps
cp /vagrant/lib/jena-fuseki-war-2.4.0.war $CAT_HOME/webapps/fuseki.war
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
# setup as service listening on $MAIN_PORT
echo ">>>> setting up ${SVC_DESC} as service"
erb /vagrant/conf/tomcat/service.erb > /etc/init/$SVC.conf
echo ">>>> starting ${SVC} service"
initctl reload-configuration
initctl start $SVC
cp /vagrant/conf/fuseki/shiro.ini $THE_HOME/base/
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"
