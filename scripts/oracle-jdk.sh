#!/usr/bin/env bash

#if which java >/dev/null; then
#   	echo "skip java 8 installation"
#else
	echo "java 8 installation"
	echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
	echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
	apt install dirmngr
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C2518248EEA14886
	apt update
	echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
	echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections
	apt install --yes oracle-java8-installer oracle-java8-set-default
	yes "" | apt-get -f install
#fi