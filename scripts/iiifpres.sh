#!/usr/bin/env bash

#general vars
echo ">>>> Installing iiifpres"
export TC_USER=iiifpres
export TC_GROUP=iiifpres
# set erb vars
export SVC=iiifpres
export SVC_DESC="IIIF Presentation API for BUDA"
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC
export MAIN_PORT=13480
export MAX_MEM="-Xmx1024M"

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $THE_HOME $TC_USER

# place to download non apt-get items
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install iiifpres
echo ">>>> installing iiifpres"
cp /vagrant/conf/iiifpres/update.sh $THE_HOME/update.sh
chmod a+x $THE_HOME/update.sh
bash $THE_HOME/update.sh

# fix permissions
echo ">>>> fixing permissions"
chown -R $USER:$USER $DOWNLOADS
chown -R $TC_USER:$TC_GROUP $THE_HOME

echo ">>>> setting up ${SVC} as service listening on ${MAIN_PORT}"
erb /vagrant/conf/spring/systemd.erb > /etc/systemd/system/$SVC.service
echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> iiifpres provisioning complete"
