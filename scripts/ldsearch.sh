#!/usr/bin/env bash

echo ">>>> Installing lds-search application..."

export TMP=/usr/local/ldsTemp
if [ -d /mnt/data ] ; then 
  export TOMCAT_DIR=/mnt/data/fuseki/tomcat/webapps/ ; 
else
  export TOMCAT_DIR=/usr/local/fuseki/tomcat/webapps/ ;
fi

mkdir -p $TMP
cd $TMP

echo ">>>> Cloning lds-search github repository..."

git clone https://github.com/BuddhistDigitalResourceCenter/lds-search.git
cd lds-search

echo ">>>> Checking out version 92b9506 ..."
git checkout 92b9506

echo ">>>> OK : Cloning and checkout completed..."
echo ">>>> Compiling and packaging lds-search application ..."
mvn clean package
echo ">>>> OK : packaging is complete"
echo ">>>> deploying lds-search application and performing cleanup"
cd target


mv lds-search.war $TOMCAT_DIR
rm -R $TMP



