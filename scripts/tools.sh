#!/usr/bin/env bash

echo ">>>> upgrade packages"
apt update -y
apt upgrade -y

#install common tools and utilities
echo ">>>> installing common tools and utilities"
echo ">>>> installing python setup tools"
apt-get install python-dev libxml2-dev libxslt-dev libyaml-dev -y
apt-get install python-setuptools -y
echo ">>>> installing various common tools"
# ruby needed for erb
apt-get install tree git bash-completion sudo vim curl jq wget ruby maven -y
echo ">>>> common tools and utilities installed"