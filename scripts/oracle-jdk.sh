#!/usr/bin/env bash

#if which java >/dev/null; then
#   	echo "skip java 8 installation"
#else
	# echo "java 8 installation"
	# echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
	# echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
	# apt install dirmngr -y
	# apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C2518248EEA14886
	# apt update
	# echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
	# echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections
	# apt install --yes oracle-java8-installer oracle-java8-set-default
	# yes "" | apt-get -f install
#fi

if [ $(dpkg-query -W -f='${Status}' oracle-java8-jdk 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo "deb http://http.debian.net/debian stretch contrib" >> /etc/apt/sources.list
	apt-get update
	apt-get -y install java-package curl java-common
	echo "downloading oracle jdk, may take some time"
	curl -s -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz > jdk-8u161-linux-x64.tar.gz
	yes | sudo -u vagrant fakeroot make-jpkg jdk-8u161-linux-x64.tar.gz
	dpkg -i oracle-java8-jdk_8u161_amd64.deb
	update-alternatives --auto java
fi
