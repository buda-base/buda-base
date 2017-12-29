#!/usr/bin/env bash

echo ">>>> Installing lds-search application..."

export TMP=/usr/local/ldsTemp
if [ -d /mnt/data ] ; then 
  export TOMCAT_DIR=/mnt/data/fuseki/tomcat/webapps/ ; 
  export FUSEKI_LIB=/mnt/data/fuseki/tomcat/webapps/fuseki/WEB-INF/lib/ ;
else
  export TOMCAT_DIR=/usr/local/fuseki/tomcat/webapps/ ;
  export FUSEKI_LIB=/usr/local/fuseki/tomcat/webapps/fuseki/WEB-INF/lib/ ;
fi

mkdir -p $TMP
cd $TMP

echo ">>>> Getting apache common-text lib from maven"

wget -q -c http://central.maven.org/maven2/org/apache/commons/commons-text/1.2/commons-text-1.2.jar
cp commons-text-1.2.jar $FUSEKI_LIB

echo ">>>> Cloning lds-search github repository..."

git clone https://github.com/BuddhistDigitalResourceCenter/lds-search.git
cd lds-search

echo ">>>> Checking out version ae9bbde ..."
git checkout ae9bbde

echo ">>>> OK : Cloning and checkout completed..."
echo ">>>> Compiling and packaging lds-search application ..."
mvn clean package
echo ">>>> OK : packaging is complete"
echo ">>>> deploying lds-search application and performing cleanup"
cd target

mv lds-search.war $TOMCAT_DIR
cp lds-search-classes.jar $FUSEKI_LIB
cd $FUSEKI_LIB
chmod 660 lds-search-classes.jar lds-search.war commons-text-1.2.jar
chown fuseki:fuseki lds-search-classes.jar lds-search.war commons-text-1.2.jar
rm -R $TMP

echo ">>>> Stop then restart tomcat fuseki ..."

systemctl stop fuseki
systemctl start fuseki



