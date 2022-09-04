#!/usr/bin/env bash

#general vars
echo ">>>> Installing Fuseki"
export TC_USER=fuseki
export TC_GROUP=fuseki
export TOMCAT_VER=10.0.23
export TC_REL="http://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz"
# set erb vars
# endpoint name for fuseki
export EP_NAME=core
export SVC=fuseki
export SVC_DESC="Jena-Fuseki Tomcat container"
export MARPLE_SVC=marple
export MARPLE_SVC_DESC="Marple service for fuseki Lucene indexes"
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
# FUSEKI VARS
# the following two lines are for BDRC specific releases
# export FUSEKI_WAR="jena-fuseki-war-3.10.0-SNAPSHOT.war"
# export FUSEKI_ZIP="https://github.com/buda-base/jena/releases/download/3.10.0-SNAP_04/${FUSEKI_WAR}.zip"
# the following four lines are for official Apache releases
export FUSEKI_DIR="apache-jena-fuseki-4.6.0"
export FUSEKI_BIN="${FUSEKI_DIR}.tar.gz"
export FUSEKI_REL="https://archive.apache.org/dist/jena/binaries/${FUSEKI_BIN}"
export FUSEKI_WAR="fuseki.war"
# BUDA Lucene analyzers
export LUCENE_BO_VER=1.7.0
export LUCENE_BO_JAR="lucene-bo-${LUCENE_BO_VER}.jar"
export LUCENE_BO_REL="https://github.com/buda-base/lucene-bo/releases/download/v${LUCENE_BO_VER}/${LUCENE_BO_JAR}"
export LUCENE_KM_VER=0.0.1
export LUCENE_KM_JAR="lucene-km-${LUCENE_BO_VER}.jar"
export LUCENE_KM_REL="https://github.com/buda-base/lucene-km/releases/download/v${LUCENE_BO_VER}/${LUCENE_BO_JAR}"
export LUCENE_ZH_VER=0.4.2
export LUCENE_ZH_JAR="lucene-zh-${LUCENE_ZH_VER}.jar"
export LUCENE_ZH_REL="https://github.com/buda-base/lucene-zh/releases/download/v${LUCENE_ZH_VER}/${LUCENE_ZH_JAR}"
export LUCENE_SA_VER=1.3.0
export LUCENE_SA_JAR="lucene-sa-${LUCENE_SA_VER}.jar"
export LUCENE_SA_REL="https://github.com/buda-base/lucene-sa/releases/download/v${LUCENE_SA_VER}/${LUCENE_SA_JAR}"
export BDRC_LIBRARIES_VER=0.18.0
export BDRC_LIBRARIES_JAR=bdrc-libraries-${BDRC_LIBRARIES_VER}.jar
export BDRC_LIBRARIES_REL="https://repo.maven.apache.org/maven2/io/bdrc/libraries/bdrc-libraries/${BDRC_LIBRARIES_VER}/${BDRC_LIBRARIES_JAR}"
export MARPLE_REL="https://github.com/flaxsearch/marple/releases/download/v1.0/marple-1.0.jar"
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: ${DATA_DIR}"
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC
export THE_BASE=$THE_HOME/base
export CAT_HOME=$THE_HOME/tomcat
export SHUTDOWN_PORT=13105
export MAIN_PORT=13180
export REDIR_PORT=13143
export AJP_PORT=13109
export MAX_MEM="-Xmx4096M"
export LUCENE_INDEX=lucene-$EP_NAME
export MARPLE_APP_PORT=13190
export MARPLE_ADM_PORT=13191
export MARPLE_JAR=marple-1.0.jar
export MARPLE_HOME=$THE_HOME/marple

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $THE_HOME $TC_USER

# place to download non apt-get items
mkdir -p $DOWNLOADS

# install tomcat container
# download tomcat
echo ">>>> downloading tomcat 8"
pushd $DOWNLOADS;
wget -q -c $TC_REL
# unpack tomcat
echo ">>>> unpacking tomcat 8"
mkdir -p $CAT_HOME
tar xf $DOWNLOADS/apache-tomcat-$TOMCAT_VER.tar.gz -C $CAT_HOME --strip-components=1
# configure server
echo ">>>> configuring server.xml tomcat 8"
erb /vagrant/conf/tomcat/server.xml.erb > $CAT_HOME/conf/server.xml
# enable tomcat admin and manager apps
cp  /vagrant/conf/tomcat/tomcat-users.xml $CAT_HOME/conf/
cp  /vagrant/conf/tomcat/web.xml $CAT_HOME/conf/
popd

# download fuseki
echo ">>>> downloading jena-fuseki war"
pushd $DOWNLOADS;
# INSTALL FROM BDRC GITHUB
# echo ">>>>>>>> wget -q -c ${FUSEKI_ZIP}"
# wget -q -c $FUSEKI_ZIP
# unzip $FUSEKI_WAR.zip
# cp $FUSEKI_WAR $CAT_HOME/webapps/fuseki.war
# INSTALL FROM APACHE
echo ">>>>>>>> wget -q -c ${FUSEKI_REL}"
wget -q -c $FUSEKI_REL
echo ">>>>>>>> tar xf ${FUSEKI_BIN}"
tar xf $FUSEKI_BIN
echo ">>>> copying ${FUSEKI_WAR} to ${CAT_HOME}/webapps/fuseki.war"
pushd $FUSEKI_DIR
cp $FUSEKI_WAR $CAT_HOME/webapps/fuseki.war
popd
popd

echo ">>>> configuring FUSEKI_BASE"
mkdir -p $THE_BASE
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
erb /vagrant/conf/fuseki/systemd.erb > /etc/systemd/system/$SVC.service
echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
# wait for fuseki to finish initializing $THE_BASE
sleep 5
systemctl stop $SVC
echo ">>>> updating ${SVC} configuration"
mkdir -p $THE_BASE/configuration

echo ">>>>>>>> adding shiro.ini to {$THE_BASE}/"
cp /vagrant/conf/fuseki/shiro.ini $THE_BASE/

echo ">>>>>>>> updating {$EP_NAME}.ttl to {$THE_BASE}/configuration/"
erb /vagrant/conf/fuseki/ttl.erb > $THE_BASE/configuration/$EP_NAME.ttl

echo ">>>>>>>> updating auth.ttl to {$THE_BASE}/configuration/"
erb /vagrant/conf/fuseki/auth.ttl.erb > $THE_BASE/configuration/auth.ttl

echo ">>>>>>>> adding qonsole-config.js to {$CAT_HOME}/webapps/fuseki/js/app/"
cp /vagrant/conf/fuseki/qonsole-config.js $CAT_HOME/webapps/fuseki/js/app/

echo ">>>>>>>> adding analyzers to {$CAT_HOME}/webapps/fuseki/WEB-INF/lib/"
# the lucene-xx and bdrc-libraries jars have to be added to fuseki/WEB-INF/lib/ after 
# initial unpacking of the fuseki war file
pushd $DOWNLOADS;
wget -q -c $LUCENE_BO_REL
cp $LUCENE_BO_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
wget -q -c $LUCENE_KM_REL
cp $LUCENE_KM_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
wget -q -c $LUCENE_ZH_REL
cp $LUCENE_ZH_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
wget -q -c $LUCENE_SA_REL
cp $LUCENE_SA_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
wget -q -c $BDRC_LIBRARIES_REL
cp $BDRC_LIBRARIES_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
popd

# put a copy of the log4j.properties in $THE_BASE for use in development
echo ">>>>>>>> copying log4j.properties to {$THE_BASE}/"
cp /vagrant/conf/fuseki/log4j.properties $THE_BASE/

echo ">>>> restarting ${SVC}"
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> adding ${THE_HOME}/load-fuseki.sh"
erb /vagrant/conf/fuseki/load-fuseki.erb > $THE_HOME/load-fuseki.sh

# install Marple Lucene index monitor
echo ">>>> installing Marple Lucene index monitor"
pushd $DOWNLOADS;
wget -q -c $MARPLE_REL
mkdir $MARPLE_HOME
cp $MARPLE_JAR $MARPLE_HOME/
popd

echo ">>>> setting up ${MARPLE_SVC} as service"
erb /vagrant/conf/marple/systemd.erb > /etc/systemd/system/$MARPLE_SVC.service

echo ">>>> creating ${MARPLE_HOME}/config.yml"
erb /vagrant/conf/marple/config.erb > $MARPLE_HOME/config.yml

echo ">>>> fixing permissions after updating ${MARPLE_SVC} configuration"
chown -R $TC_USER:$TC_GROUP $THE_HOME

echo ">>>> starting ${MARPLE_SVC} service"
systemctl daemon-reload
systemctl enable $MARPLE_SVC
# systemctl start $MARPLE_SVC
echo ">>>> Marple will have to be manually started the first time after the Lucene index is built"

cp /vagrant/conf/fuseki/update.sh $THE_HOME
chmod a+x $THE_HOME/update.sh
cp /vagrant/conf/fuseki/update-ttl-config.sh $THE_HOME
chmod a+x $THE_HOME/update-ttl-config.sh

echo ">>>> fuseki provisioning complete"
