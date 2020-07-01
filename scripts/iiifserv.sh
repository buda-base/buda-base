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

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

sudo apt install libturbojpeg0 -y -q

echo ">>>> DATA_DIR: " $DATA_DIR
echo ">>>> JAVA_HOME: " $JAVA_HOME
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC
export IIIFSERV="buda-iiif-server"
export MAIN_PORT=13580
export EXECFILE=buda-hymir-exec.jar
export JAVA_EXTRA_ARGS=-Dspring.config.location=file:/etc/buda/$SVC/application.yml

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
git clone https://github.com/buda-base/buda-iiif-server.git

cd $IIIFSERV

#install external Webp jar
wget -q https://github.com/buda-base/buda-iiif-server/releases/download/0.1/webp-imageio-core-0.1.0.jar
mvn -B install:install-file -Dfile=webp-imageio-core-0.1.0.jar -DgroupId=iiif.bdrc.io -DartifactId=webp-imageio -Dversion=0.1.0 -Dpackaging=jar

mvn -B package
chown $TC_USER:$TC_GROUP target/*.war
cp target/*-exec.war $THE_HOME/$EXECFILE

mkdir -p /etc/buda/iiifserv
erb /vagrant/conf/spring/logback.xml.erb > /etc/buda/iiifserv/logback.xml

cp /vagrant/conf/iiifserv/update.sh $THE_HOME/

echo ">>>> fixing permissions"
chown -R $TC_USER:$TC_GROUP $THE_HOME

echo ">>>> setting up ${SVC} as service listening on ${MAIN_PORT}"
erb /vagrant/conf/spring/systemd.erb > /etc/systemd/system/$SVC.service

echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> iiifserv provisioning complete"
