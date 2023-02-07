#!/usr/bin/env bash

echo ">>>> Installing prerender..."
export SVC="prerender"
export SVC_DESC="Prerender"
export TC_USER=prerender
export TC_GROUP=prerender
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC

# requires google-chrome
wget -q -P $DOWNLOADS https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install $DOWNLOADS/google-chrome-stable_current_amd64.deb

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $THE_HOME $TC_USER

mkdir -p $THE_HOME

pushd $THE_HOME
if [ ! -d $THE_HOME/prerender ] ; then 
  	echo ">>>> downloading & installing prerender" 
    git clone https://github.com/prerender/prerender.git    
fi
popd

# fix permissions
echo ">>>> fixing permissions"
chown -R $TC_USER:$TC_GROUP $THE_HOME

pushd $THE_HOME/prerender
npm install
echo "const prerender = require('prerender');" > server.js
echo "var server = prerender({chromeFlags: [ '--no-sandbox', '--headless', '--remote-debugging-port=9222',  /* not needed? --> */ '--disable-gpu', '--disable-software-rasterizer', '--disable-dev-shm-usage','--hide-scrollbars' ] });" >> server.js
echo "server.start();" >> server.js
popd

echo ">>>> setting up ${SVC} as service listening on ${MAIN_PORT}"
erb /vagrant/conf/prerender/systemd.erb > /etc/systemd/system/$SVC.service
echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
echo ">>>> ${SVC} service listening on 14019"

echo 'test with curl --user-agent "Googlebot/2.1 (+http://www.google.com/bot.html)" -v https://library.bdrc.io/show/bdr:WA0BC001'
