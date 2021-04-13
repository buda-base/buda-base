#!/usr/bin/env bash

echo ">>>> Updating iiif server"
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
export TC_USER=editserv
export TC_GROUP=editserv
export SVC=editserv
export DOWNLOADS="$DATA_DIR/downloads"
export EDITSERV="editserv"
export THE_HOME=$DATA_DIR/$SVC

service editserv stop

echo ">>>> cloning iiifserv"
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install iiifserv
echo ">>>> installing iiif server"
rm -rf --preserve-root $DOWNLOADS/editserv
pushd $DOWNLOADS;
git clone https://github.com/buda-base/editserv.git
cd editserv
if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi

mvn -B clean package -Deditserv.configpath=/etc/buda/editserv/

chown $TC_USER:$TC_GROUP target/*.jar
cp target/*-exec.jar $THE_HOME/editserv-exec.jar

popd

service editserv start

echo ">>>> editserv was updated"