#!/usr/bin/env bash

# install Oracle jdk
echo ">>>> installing Oracle JDK 8"
if which java >/dev/null; then
   	echo "skip java 8 installation"
else
	echo "java 8 installation"
	apt-get install --yes python-software-properties
	add-apt-repository ppa:webupd8team/java -y
	apt-get update -y
	echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
	echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections
	apt-get install --yes oracle-java8-installer
	yes "" | apt-get -f install
fi


# install couchdb and dependencies
echo ">>>> installing couchdb and dependencies"
sudo add-apt-repository ppa:couchdb/stable -y
sudo apt-get update -y
# remove any existing couchdb binaries
sudo apt-get remove couchdb couchdb-bin couchdb-common -yf
sudo apt-get install -V couchdb -y
# manage via upstart for Ubuntu 14.04 LTS
sudo stop couchdb
# update /etc/couchdb/local.ini with 'bind_address=0.0.0.0' as needed
sudo start couchdb
echo ">>>> couchdb listening on 5984"


# install Node.js; npm; and n
echo ">>>> installing node.js; npm; and n"
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g n
# to update node.js use
# sudo npm cache clean -f
# sudo n stable


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


# install RabbitMQ
echo ">>>> installing RabbitMQ adn cients"
sudo apt-get install rabbitmq-server -y
sudo apt-get install amqp-tools -y
sudo npm install rabbit.js


# install jena


# install elastic search


