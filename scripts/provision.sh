#!/usr/bin/env bash

# install Oracle jdk

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

sudo add-apt-repository ppa:couchdb/stable -y
sudo apt-get update -y
# remove any existing couchdb binaries
sudo apt-get remove couchdb couchdb-bin couchdb-common -yf
sudo apt-get install -V couchdb -y
# manage via upstart for Ubuntu 14.04 LTS
sudo stop couchdb
# update /etc/couchdb/local.ini with 'bind_address=0.0.0.0' as needed
sudo start couchdb


# install Node.js


# install RabbitMQ


# install jena


# install elastic search
