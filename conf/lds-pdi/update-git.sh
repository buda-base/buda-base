#!/usr/bin/env bash

# this script updates a previous lds-pdi install
# run as:
#
#    sudo ./update.sh classes
#
# or remove classes if you don't want to update the classes for fuseki

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

export CLASSES=$1

echo ">>>> Downloading lds-pdi "
cd $DOWNLOADS

rm -rf --preserve-root lds-pdi
git clone https://github.com/BuddhistDigitalResourceCenter/lds-pdi.git
cd lds-pdi
mvn clean package
chown ldspdi:ldspdi target/lds-pdi.war

cp target/lds-pdi.war $LDSPDI_HOME/tomcat/webapps/ROOT.war

if [ "$CLASSES" -eq "classes" ] ; then
	echo ">>>> updating fuseki lds-pdi-classes.jar"
	cp target/lds-pdi-classes.jar $FUSEKI_LIB/lds-pdi-classes.jar
	systemctl restart fuseki
	echo ">>>> fuseki restarted"
fi
rm -rf --preserve-root $DOWNLOADS/lds-pdi
echo ">>>> lds-pdi updated"
