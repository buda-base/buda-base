#!/usr/bin/env bash

#general vars
echo ">>>> Installing edit server"
export TC_USER=editserv
export TC_GROUP=editserv
export SVC=editserv
export SVC_DESC="BUDA EDIT Server"
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
#export JAVA_HOME=/opt/java-jdk/jdk1.8.0_151
echo $JAVA_HOME

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

echo ">>>> DATA_DIR: " $DATA_DIR
echo ">>>> JAVA_HOME: " $JAVA_HOME
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC
export EDITSERV="editserv"
export MAIN_PORT=13880

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
git clone https://github.com/buda-base/editserv.git

cd $EDITSERV

mvn -B package
chown $TC_USER:$TC_GROUP target/*.jar
cp target/editserv-exec.jar $THE_HOME/editserv-exec.jar

cp /vagrant/conf/editserv/update.sh $THE_HOME/

echo ">>>> fixing permissions"
chown -R $TC_USER:$TC_GROUP $THE_HOME

# setup as Debian systemctl service listening on 15880
echo ">>>> setting up ${EDITSERV} as service listening on 15880"
erb /vagrant/conf/editserv/systemd.erb > /etc/systemd/system/$SVC.service

echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> editserv provisioning complete"