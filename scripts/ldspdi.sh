#!/usr/bin/env bash

echo ">>>> Installing lds-pdi application..."

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export FUSEKI=fuseki
export FUSEKI_HOME=$DATA_DIR/$FUSEKI
export TOMCAT_DIR=$FUSEKI_HOME/tomcat/webapps
export FUSEKI_LIB=$TOMCAT_DIR/fuseki/WEB-INF/lib

echo ">>>> Downloading apache common-text lib from maven"
pushd $DOWNLOADS;
wget -q -c "http://central.maven.org/maven2/org/apache/commons/commons-text/1.2/commons-text-1.2.jar"
cp commons-text-1.2.jar $FUSEKI_LIB/

echo ">>>> Downloading lds-pdi 0.1"
wget -q -c "https://github.com/BuddhistDigitalResourceCenter/lds-pdi/releases/download/v0.1/lds-pdi.zip"
unzip lds-pdi.zip

cp lds-pdi.war $TOMCAT_DIR/
cp lds-pdi-classes.jar $FUSEKI_LIB/
popd

cd $FUSEKI_LIB
chmod 660 $FUSEKI_LIB/lds-pdi-classes.jar $TOMCAT_DIR/lds-pdi.war $FUSEKI_LIB/commons-text-1.2.jar
chown fuseki:fuseki $FUSEKI_LIB/lds-pdi-classes.jar $TOMCAT_DIR/lds-pdi.war $FUSEKI_LIB/commons-text-1.2.jar


echo ">>>> restart fuseki ..."

systemctl stop fuseki
systemctl start fuseki

echo ">>>> lds-pdi application installed ..."

