#!/usr/bin/env bash

echo ">>>> Installing lds-pdi application..."
export SVC_DESC="Linked Data Service - Public Data Interface container"
export TC_USER=ldspdi
export TC_GROUP=ldspdi
export TOMCAT_VER=8.0.42
export TC_REL="http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz"

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ;
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
export FUSEKI=fuseki
export FUSEKI_HOST=localhost
export FUSEKI_PORT=13180
export FUSEKI_HOME=$DATA_DIR/$FUSEKI
export FUSEKI_WEBAPPS=$FUSEKI_HOME/tomcat/webapps
export FUSEKI_LIB=$FUSEKI_WEBAPPS/fuseki/WEB-INF/lib

export LDSPDI=ldspdi
export LDSPDI_HOME=$DATA_DIR/$LDSPDI
export QUERIES_HOME=$LDSPDI_HOME/queries/
export CAT_HOME=$LDSPDI_HOME/tomcat
export SHUTDOWN_PORT=13205
export MAIN_PORT=13280
export REDIR_PORT=13243
export AJP_PORT=13209
export MAX_MEM="-Xmx4096M"

export LDSPDI_WEBAPPS=$CAT_HOME/webapps

mkdir -p $CAT_HOME

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $LDSPDI_HOME $TC_USER


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
erb /vagrant/conf/lds-pdi/context.xml.erb > $CAT_HOME/conf/context.xml
cp /vagrant/conf/lds-pdi/update.sh $LDSPDI_HOME/


# common-text is used in fuseki extensions called from queries via lds-pdi
echo ">>>> Downloading apache common-text lib from maven"
pushd $DOWNLOADS;
mkdir $LDSPDI
pushd $LDSPDI
wget -q -c "http://central.maven.org/maven2/org/apache/commons/commons-text/1.2/commons-text-1.2.jar"
cp commons-text-1.2.jar $FUSEKI_LIB/

echo ">>>> Downloading lds-pdi 0.8.15"
wget -q -c "https://github.com/BuddhistDigitalResourceCenter/lds-pdi/releases/download/v0.8.15/lds-pdi.zip"
unzip -q lds-pdi.zip

echo ">>>> move webapps/ROOT to admin so ldspdi runs as ROOT"
pushd $LDSPDI_WEBAPPS
mv ROOT admin
popd

echo ">>>> cp lds-pdi.war $LDSPDI_WEBAPPS/ROOT.war"
cp lds-pdi.war $LDSPDI_WEBAPPS/ROOT.war
# the lds-pdi-classes are sparql extension functions used in queries from lds-pdi
cp lds-pdi-classes.jar $FUSEKI_LIB/

popd
popd

echo ">>>> fixing permissions"
chown -R $USER:$USER $DOWNLOADS
chown -R $TC_USER:$TC_GROUP $LDSPDI_HOME

chmod 660 $FUSEKI_LIB/lds-pdi-classes.jar $FUSEKI_LIB/commons-text-1.2.jar
chown fuseki:fuseki $FUSEKI_LIB/lds-pdi-classes.jar $FUSEKI_LIB/commons-text-1.2.jar


# setup as Debian systemctl service listening on $MAIN_PORT
echo ">>>> setting up ${LDSPDI} as service listening on ${MAIN_PORT}"
erb /vagrant/conf/tomcat/systemd.erb > /etc/systemd/system/$LDSPDI.service
echo ">>>> starting ${LDSPDI} service"
systemctl daemon-reload
systemctl enable $LDSPDI
systemctl start $LDSPDI

echo ">>>> fixing permissions 2"
chown -R $TC_USER:$TC_GROUP $LDSPDI_HOME
pushd $CAT_HOME
chmod g+rwx conf webapps
chmod g+r conf/*
popd

echo ">>>> restart fuseki to pickup lds-pdi dependencies"

systemctl stop fuseki
systemctl start fuseki

echo ">>>> lds-pdi application installed ..."
