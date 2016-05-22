#!/usr/bin/env bash

# install tomcat
# add tomcat user
echo ">>>> adding tomcat user"
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
# place to download non apt-get items
mkdir -p /home/vagrant/downloads
# download tomcat
echo ">>>> downloading tomcat 8"
pushd /home/vagrant/downloads;
wget http://mirror.sdunix.com/apache/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz
popd
# allow for several tomcat instances tomcat001, tomcat002, ...
sudo mkdir -p /usr/local/tomcat001
# unpack tomcat
echo ">>>> unpacking tomcat 8"
sudo tar xvf /home/vagrant/downloads/apache-tomcat-8*tar.gz -C /usr/local/tomcat001 --strip-components=1
# fix permissions
echo ">>>> fixing tomcat001 permissions"
pushd /usr/local/tomcat001
sudo chgrp -R tomcat conf webapps
sudo chmod g+rwx conf webapps
sudo chmod g+r conf/*
sudo chown -R tomcat work/ temp/ logs/ webapps/
popd
# setup tomcat001 as service - initially on port 8080
echo ">>>> setting up tomcat001 as service and starting"
sudo cp /vagrant/scripts/tomcat001.conf /etc/init/tomcat001.conf
sudo initctl reload-configuration
sudo initctl start tomcat001
echo ">>>> tomcat001 listening on 8080"
