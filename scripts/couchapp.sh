#!/usr/bin/env bash

# install couchapp
echo ">>>> installing couchapp"
sudo apt-get install python-dev libxml2-dev libxslt-dev -y
sudo apt-get install python-setuptools
sudo easy_install -U setuptools
sudo easy_install -U couchapp
echo ">>>> couchapp installed"
