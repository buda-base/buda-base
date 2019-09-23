#!/usr/bin/env bash

echo ">>>> update packages"
apt-get -y -qq update
# now start bootstrapping and upgrading your system packages
echo ">>>> upgrade packages"
DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq


#install common tools and utilities
echo ">>>> installing common tools and utilities"
echo ">>>> installing python-dev"
apt-get install python-dev  -y -qq
echo ">>>> installing libxml2-dev"
apt-get install libxml2-dev  -y -qq
echo ">>>> installing libxslt-dev"
apt-get install libxslt-dev  -y -qq
echo ">>>> installing libyaml-dev"
apt-get install libyaml-dev  -y -qq
echo ">>>> installing python-setuptools"
apt-get install python-setuptools  -y -qq
echo ">>>> installing python3-pip"
apt-get install python3-pip  -y -qq
echo ">>>> installing lsof"
apt-get install lsof -y -qq
echo ">>>> pip3 install sparqlwrapper"
pip3 install sparqlwrapper -qq
echo ">>>> installing tree"
apt-get install tree -y -qq
echo ">>>> installing git"
apt-get install git -y -qq
echo ">>>> installing bash-completion"
apt-get install bash-completion -y -qq
echo ">>>> installing sudo"
apt-get install sudo -y -qq
echo ">>>> installing vim"
apt-get install vim -y -qq
echo ">>>> installing curl"
apt-get install curl -y -qq
echo ">>>> installing jq"
apt-get install jq -y -qq
echo ">>>> installing wget"
apt-get install wget -y -qq
echo ">>>> installing ruby"
apt-get install ruby -y -qq
echo ">>>> installing maven"
apt-get install maven -y -qq
echo ">>>> installing php"
apt-get install php -y -qq
apt-get install php7.0-mbstring php7.0-zip php7.0-xml -y -qq
echo ">>>> common tools and utilities installed"