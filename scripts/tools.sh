#!/usr/bin/env bash

#install common tools and utilities
echo ">>>> installing common tools and utilities"
echo ">>>> installing python setup tools"
apt-get install python-dev libxml2-dev libxslt-dev -y
apt-get install python-setuptools
easy_install -U setuptools
echo ">>>> installing directory tree util"
apt-get install tree -y
echo ">>>> common tools and utilities installed"
