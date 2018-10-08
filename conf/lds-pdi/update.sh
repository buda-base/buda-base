#!/usr/bin/env bash

# this script updates a previous lds-pdi install
# run as:
#
#    sudo update.sh v0.4.5

echo ">>>> updating ldspdi"

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

export DOWNLOADS="$DATA_DIR/downloads"
export LDSPDI="ldspdi"
export LDSPDI_HOME="$DATA_DIR/$LDSPDI"
export FUSEKI=fuseki
export FUSEKI_HOME=$DATA_DIR/$FUSEKI
export FUSEKI_WEBAPPS=$FUSEKI_HOME/tomcat/webapps
export FUSEKI_LIB=$FUSEKI_WEBAPPS/fuseki/WEB-INF/lib

export VER=$1
export CLASSES=$2

echo ">>>> Downloading lds-pdi ${VER}"
pushd $DOWNLOADS;
rm -f $LDSPDI
git clone https://github.com/BuddhistDigitalResourceCenter/lds-pdi.git
pushd $DOWNLOADS/$LDSPDI;
mvn -B clean package
mv target/lds-pdi.war target/lds-pdi-$VER.war
mv target/lds-pdi-classes.jar target/lds-pdi-classes-$VER.jar
chown ldspdi:ldspdi target/lds-pdi-$VER.war

cp target/lds-pdi-$VER.war $LDSPDI_HOME/tomcat/webapps/ROOT.war

if [ "$CLASSES" -eq "classes" ] ; then
	echo ">>>> updating fuseki lds-pdi-classes.jar"
	cp target/lds-pdi-classes-$VER.jar $FUSEKI_LIB/lds-pdi-classes.jar
	systemctl restart fuseki
	echo ">>>> fuseki restarted"
fi

echo ">>>> lds-pdi updated to ${VER}"
