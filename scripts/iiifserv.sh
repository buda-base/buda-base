#!/usr/bin/env bash

#general vars
echo ">>>> Installing iiif server"
export TC_USER=iiifserv
export TC_GROUP=iiifserv
export SVC=iiifserv
export SVC_DESC="BUDA IIIF Server"
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
#export JAVA_HOME=/opt/java-jdk/jdk1.8.0_151
echo $JAVA_HOME
export DATA_DIR=/usr/local

sudo apt install libturbojpeg0-dev

echo ">>>> DATA_DIR: " $DATA_DIR
echo ">>>> JAVA_HOME: " $JAVA_HOME
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC
export IIIFSERV="buda-iiif-server"
export MAIN_PORT=13580

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $THE_HOME $TC_USER

# place to download non apt-get items
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install iiifserv
echo ">>>> installing iiif server"
cd $DOWNLOADS;
git clone https://github.com/BuddhistDigitalResourceCenter/buda-iiif-server.git
cd $IIIFSERV
mvn package
chown $TC_USER:$TC_GROUP target/*.jar
cp target/buda-hymir-1.0.0-SNAPSHOT-exec.jar $THE_HOME/buda-hymir-exec.jar

echo ">>>> fixing permissions"
chown -R $TC_USER:$TC_GROUP $THE_HOME

# setup as Debian systemctl service listening on 15680
echo ">>>> setting up ${IIIFSERV} as service listening on 15580"
erb /vagrant/conf/iiifserv/systemd.erb > /etc/systemd/system/$SVC.service

echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> iiifserv provisioning complete"