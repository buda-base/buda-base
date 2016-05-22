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
