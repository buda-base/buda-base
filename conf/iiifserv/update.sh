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
export AWS_CREDENTIAL_PROFILES_FILE=/etc/buda/iiifserv/credentials

service iiifserv stop

echo ">>>> cloning iiifserv"
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install iiifserv
echo ">>>> installing iiif server"
pushd $DOWNLOADS;
if [ -d buda-iiif-server ] ; then 
  cd buda-iiif-server ;
  git pull ; 
else
  git clone https://github.com/buda-base/buda-iiif-server.git ;
  cd buda-iiif-server ;
fi

if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi

mvn -B clean package -Diiifserv.configpath=/etc/buda/iiifserv/ -Dspring.config.location=file:/etc/buda/iiifserv/application.yml

chown $TC_USER:$TC_GROUP target/*.war
cp target/*-exec.war $THE_HOME/buda-hymir-exec.war

popd
#rm -rf --preserve-root $DOWNLOADS/$IIIFSERV

service iiifserv start

echo ">>>> iiifserv was updated"
