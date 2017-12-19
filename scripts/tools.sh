#!/usr/bin/env bash

echo ">>>> upgrade packages"
apt update -y
apt upgrade -y

#install common tools and utilities
echo ">>>> installing common tools and utilities"
echo ">>>> installing python setup tools"
apt-get install python-dev libxml2-dev libxslt-dev libyaml-dev -y
apt-get install python-setuptools
echo ">>>> installing various common tools"
# ruby needed for erb
apt-get install tree git bash-completion sudo vim curl jq wget ruby -y
echo ">>>> common tools and utilities installed"

# Install git and maven for application integration
echo ">>>> installing git"
apt-get install git-core
echo ">>>> OK : Git installation completed"
echo ">>>> installing Maven tools"
apt-get install maven
echo ">>>> OK : Maven installation completed"