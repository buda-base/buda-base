#!/usr/bin/env bash

#general vars
echo ">>>> Installing iiifpres"
export TC_USER=iiifpres
export TC_GROUP=iiifpres
export TC_REL="http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.42/bin/apache-tomcat-8.0.42.tar.gz"
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
export THE_BASE=$THE_HOME/base
export CAT_HOME=$THE_HOME/tomcat
export SHUTDOWN_PORT=13405
export MAIN_PORT=13480
export REDIR_PORT=13443
export AJP_PORT=13409
export MAX_MEM="-Xmx1024M"

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $THE_HOME $TC_USER

# place to download non apt-get items
mkdir -p $DOWNLOADS

# install tomcat container
# download tomcat
echo ">>>> downloading tomcat 8"
pushd $DOWNLOADS;
wget -q -c $TC_REL
# unpack tomcat
echo ">>>> unpacking tomcat 8"
mkdir -p $CAT_HOME
tar xf $DOWNLOADS/apache-tomcat-8*tar.gz -C $CAT_HOME --strip-components=1
# configure server
echo ">>>> configuring server.xml tomcat 8"
erb /vagrant/conf/tomcat/server.xml.erb > $CAT_HOME/conf/server.xml
# enable tomcat admin and manager apps
cp  /vagrant/conf/tomcat/tomcat-users.xml $CAT_HOME/conf/
cp  /vagrant/conf/tomcat/web.xml $CAT_HOME/conf/
popd

# install iiifpres
echo ">>>> installing iiifpres"
cp /vagrant/conf/iiifpres/update.sh $THE_HOME
chmod a+x $THE_HOME/update.sh
bash $THE_HOME/update.sh

# fix permissions
echo ">>>> fixing permissions"
chown -R $USER:$USER $DOWNLOADS
chown -R $TC_USER:$TC_GROUP $THE_HOME

pushd $CAT_HOME
# chgrp -R $TC_USER conf webapps
chmod g+rwx conf webapps
chmod g+r conf/*
# chown -R $TC_USER work/ temp/ logs/ webapps/
popd

# setup as Debian systemctl service listening on $MAIN_PORT
echo ">>>> setting up ${SVC} as service"
erb /vagrant/conf/tomcat/systemd.erb > /etc/systemd/system/$SVC.service
echo ">>>> starting ${SVC} service"

echo ">>>> restarting ${SVC}"
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> iiifpres provisioning complete"
