#!/usr/bin/env bash

echo ">>>> update packages"
apt-get update -y
echo ">>>> upgrade packages"
apt-get upgrade -y

#install common tools and utilities
echo ">>>> installing common tools and utilities"
echo ">>>> installing python-dev"
apt-get install python-dev  -y -q
echo ">>>> installing libxml2-dev"
apt-get install libxml2-dev  -y -q
echo ">>>> installing libxslt-dev"
apt-get install libxslt-dev  -y -q
echo ">>>> installing libyaml-dev"
apt-get install libyaml-dev  -y -q
echo ">>>> installing python-setuptools"
apt-get install python-setuptools  -y -q
echo ">>>> installing python-pip"
apt-get install python-pip  -y -q
echo ">>>> installing python3-pip"
apt-get install python3-pip  -y -q
echo ">>>> installing lsof"
apt-get install lsof -y -q
echo ">>>> pip3 install sparqlwrapper"
pip3 install sparqlwrapper -q
echo ">>>> installing tree"
apt-get install tree -y -q
echo ">>>> installing git"
apt-get install git -y -q
echo ">>>> installing bash-completion"
apt-get install bash-completion -y -q
echo ">>>> installing sudo"
apt-get install sudo -y -q
echo ">>>> installing vim"
apt-get install vim -y -q
echo ">>>> installing curl"
apt-get install curl -y -q
echo ">>>> installing jq"
apt-get install jq -y -q
echo ">>>> installing wget"
apt-get install wget -y -q
echo ">>>> installing ruby"
apt-get install ruby -y -q
echo ">>>> installing maven"
apt-get install maven -y -q
echo ">>>> common tools and utilities installed"