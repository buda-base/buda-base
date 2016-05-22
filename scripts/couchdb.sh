#!/usr/bin/env bash

# install couchdb and dependencies
echo ">>>> installing couchdb and dependencies"
sudo add-apt-repository ppa:couchdb/stable -y
sudo apt-get update -y
# remove any existing couchdb binaries - should not be needed
# sudo apt-get remove couchdb couchdb-bin couchdb-common -yf
sudo apt-get install -V couchdb -y
# manage via upstart for Ubuntu 14.04 LTS
sudo stop couchdb
# update /etc/couchdb/local.ini with 'bind_address=0.0.0.0' as needed
sudo cp /etc/couchdb/local.ini /etc/couchdb/local.ini.bk
sudo sed -i "/\[httpd\]/abind_address=0.0.0.0" /etc/couchdb/local.ini
sudo start couchdb
echo ">>>> couchdb listening on 5984"
