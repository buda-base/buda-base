#!/usr/bin/env bash

echo ">>>> Installing lds-pdi application..."
export SVC_DESC="Linked Data Service - Public Data Interface container"
export TC_USER=ldspdi
export TC_GROUP=ldspdi

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ;
  export LDSPDI_HOST=localhost ;
else
  export DATA_DIR=/usr/local ;
  export LDSPDI_HOST=buda1.bdrc.io ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
export FUSEKI=fuseki
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
export MAX_MEM="-Xmx2048M"

export LDSPDI_WEBAPPS=$CAT_HOME/webapps
export LDSPDI_PROPS=$LDSPDI_WEBAPPS/lds-pdi/ldspdi.properties
export LDSPDI_PROPS2=$LDSPDI_WEBAPPS/lds-pdi/WEB-INF/classes/ldspdi.properties

mkdir -p $CAT_HOME

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $LDSPDI_HOME $TC_USER


# install tomcat container
# tomcat should have been downloaded by fuseki.sh
echo ">>>> installing tomcat 8 for ldspdi"
pushd $DOWNLOADS;
tar xf $DOWNLOADS/apache-tomcat-8*tar.gz -C $CAT_HOME --strip-components=1
# configure server
echo ">>>> configuring server.xml tomcat 8"
erb /vagrant/conf/tomcat/server.xml.erb > $CAT_HOME/conf/server.xml
# enable tomcat admin and manager apps
cp  /vagrant/conf/tomcat/tomcat-users.xml $CAT_HOME/conf/
erb /vagrant/conf/lds-pdi/context.xml.erb > $CAT_HOME/conf/context.xml
popd



# common-text is used in fuseki extensions called from queries via lds-pdi
echo ">>>> Downloading apache common-text lib from maven"
pushd $DOWNLOADS;
mkdir LDSPDI
pushd LDSPDI
wget -q -c "http://central.maven.org/maven2/org/apache/commons/commons-text/1.2/commons-text-1.2.jar"
cp commons-text-1.2.jar $FUSEKI_LIB/

echo ">>>> Downloading lds-pdi 0.2"
wget -q -c "https://github.com/BuddhistDigitalResourceCenter/lds-pdi/releases/download/v0.2/lds-pdi.zip"
unzip -q lds-pdi.zip

cp target/lds-pdi.war $LDSPDI_WEBAPPS/
# the lds-pdi-classes are sparql extension functions used in queries from lds-pdi
cp target/lds-pdi-classes.jar $FUSEKI_LIB/

cp -R queries/ $LDSPDI_HOME/
popd
# ?? popd


echo ">>>> fixing permissions"
chown -R $USER:$USER $DOWNLOADS
chown -R $TC_USER:$TC_GROUP $LDSPDI_HOME

chmod 660 $FUSEKI_LIB/lds-pdi-classes.jar $FUSEKI_LIB/commons-text-1.2.jar
chown fuseki:fuseki $FUSEKI_LIB/lds-pdi-classes.jar $FUSEKI_LIB/commons-text-1.2.jar


# setup as Debian systemctl service listening on $MAIN_PORT
echo ">>>> setting up ${LDSPDI} as service"
erb /vagrant/conf/tomcat/systemd.erb > /etc/systemd/system/$LDSPDI.service
echo ">>>> starting ${LDSPDI} service"
systemctl daemon-reload
systemctl enable $LDSPDI
systemctl start $LDSPDI

# echo ">>>> configuring ${LDSPDI_PROPS}"
# sleep 5
# systemctl stop $LDSPDI
# erb /vagrant/conf/lds-pdi/properties.erb > $LDSPDI_PROPS
# erb /vagrant/conf/lds-pdi/properties.erb > $LDSPDI_PROPS2
# systemctl start $LDSPDI

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
