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

echo ">>>> cloning iiifpres"
pushd $DOWNLOADS/$IIIFPRES;

git clone https://github.com/BuddhistDigitalResourceCenter/buda-iiif-presentation.git tmpgitiiifpresentation
pushd tmpgitiiifpresentation
if [ "$#" -e 1 ]; then
    git checkout "$1"
fi
mvn war:war
chown iiifpres:iiifpres target/*.war
mv target/*.war $IIIFPRES_HOME/tomcat/webapps/ROOT.war
popd
rm -rf --preserve-root tmpgitiiifpresentation

echo ">>>> iiifpres installed"
