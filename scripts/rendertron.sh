#!/usr/bin/env bash

echo ">>>> Installing rendertron..."
export SVC="rendertron"
export SVC_DESC="Rendertron"
export TC_USER=rendertron
export TC_GROUP=rendertron
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

# so that we install all the deps:
apt install chromium-shell -y -q

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $THE_HOME $TC_USER

mkdir -p $THE_HOME

pushd $THE_HOME
if [ ! -d $THE_HOME/rendertron ] ; then 
  	echo ">>>> downloading & installing rendertron"
	git clone https://github.com/GoogleChrome/rendertron.git
fi
popd

# fix permissions
echo ">>>> fixing permissions"
chown -R $TC_USER:$TC_GROUP $THE_HOME

pushd $THE_HOME/rendertron
npm install
npm install puppeteer
npm run build
popd

echo ">>>> setting up ${SVC} as service listening on ${MAIN_PORT}"
erb /vagrant/conf/rendertron/systemd.erb > /etc/systemd/system/$SVC.service
echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
echo ">>>> ${SVC} service listening on 14019"