#!/usr/bin/env bash

echo ">>>> installing iiifpres"

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

export DOWNLOADS="$DATA_DIR/downloads"
export IIIFPRES="iiifpres"
export IIIFPRES_HOME="$DATA_DIR/$IIIFPRES"

service iiifpres stop

echo ">>>> cloning iiifpres"
mkdir -p $DOWNLOADS/$IIIFPRES
pushd $DOWNLOADS/$IIIFPRES

rm -rf --preserve-root tmpgitiiifpresentation
git clone https://github.com/BuddhistDigitalResourceCenter/buda-iiif-presentation.git tmpgitiiifpresentation
pushd tmpgitiiifpresentation
if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi
mvn clean package
chown iiifpres:iiifpres target/*.war
rm -rf --preserve-root $IIIFPRES_HOME/tomcat/webapps/ROOT
mv target/*.war $IIIFPRES_HOME/tomcat/webapps/ROOT.war
popd
rm -rf --preserve-root tmpgitiiifpresentation

service iiifpres start

echo ">>>> iiifpres installed"
