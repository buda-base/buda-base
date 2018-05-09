#!/usr/bin/env bash



echo ">>>> Updating iiif server"
export DATA_DIR=/usr/local ;
export TC_USER=iiifserv
export TC_GROUP=iiifserv
export SVC=iiifserv
export DOWNLOADS="$DATA_DIR/downloads"
export IIIFSERV="iiifserv"
export THE_HOME=$DATA_DIR/$SVC

systemctl stop iiifserver

echo ">>>> cloning iiifserv"
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install iiifserv
echo ">>>> installing iiif server"
cd $DOWNLOADS;
git clone https://github.com/BuddhistDigitalResourceCenter/buda-iiif-server.git
cd buda-iiif-server
if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi
mvn package

chown $TC_USER:$TC_GROUP target/*.jar
cp target/buda-hymir-1.0.0-SNAPSHOT-exec.jar $THE_HOME/buda-hymir-exec.jar

cd /
rm -rf $DOWNLOADS/$IIIFSERV

systemctl start iiifserver

echo ">>>> iiifserv was updated"
