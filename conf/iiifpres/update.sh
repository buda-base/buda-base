#!/usr/bin/env bash

echo ">>>> Updating iiifpres server"
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
export TC_USER=iiifpres
export TC_GROUP=iiifpres
export SVC=iiifpres
export DOWNLOADS="$DATA_DIR/downloads"
export IIIFSERV="iiifpres"
export THE_HOME=$DATA_DIR/$SVC
export AWS_CREDENTIAL_PROFILES_FILE=/etc/buda/iiifpres/credentials
export EXECFILE=buda-iiif-presentation-exec.war

service iiifpres stop

echo ">>>> cloning iiifpres"
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install iiifpres
echo ">>>> installing iiifpres server"
rm -rf --preserve-root $DOWNLOADS/buda-iiif-presentation
pushd $DOWNLOADS;
git clone https://github.com/buda-base/buda-iiif-presentation.git
cd buda-iiif-presentation
if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi

mvn -B clean package -Diiifpres.configpath=/etc/buda/$SVC/ -Dspring.config.location=file:/etc/buda/$SVC/application.yml

chown $TC_USER:$TC_GROUP target/*.war
cp target/*-exec.war $THE_HOME/$EXECFILE

popd
#rm -rf --preserve-root $DOWNLOADS/$IIIFSERV

service $SVC start

echo ">>>> iiifpres was updated"