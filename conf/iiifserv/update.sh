#!/usr/bin/env bash

echo ">>>> Updating iiif server"
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
export TC_USER=iiifserv
export TC_GROUP=iiifserv
export SVC=iiifserv
export DOWNLOADS="$DATA_DIR/downloads"
export IIIFSERV="iiifserv"
export THE_HOME=$DATA_DIR/$SVC

service iiifserv stop

echo ">>>> cloning iiifserv"
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install iiifserv
echo ">>>> installing iiif server"
rm -rf --preserve-root $DOWNLOADS/buda-iiif-server
pushd $DOWNLOADS;
git clone https://github.com/BuddhistDigitalResourceCenter/buda-iiif-server.git
cd buda-iiif-server
if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi
mvn -B clean package

chown $TC_USER:$TC_GROUP target/*.jar
cp target/*-exec.jar $THE_HOME/buda-hymir-exec.jar

popd
#rm -rf --preserve-root $DOWNLOADS/$IIIFSERV

service iiifserv start

echo ">>>> iiifserv was updated"