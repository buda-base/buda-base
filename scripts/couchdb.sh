#!/usr/bin/env bash

# install couchdb and dependencies
echo ">>>> installing couchdb and dependencies"
add-apt-repository ppa:couchdb/stable -y
apt-get update -y
# remove any existing couchdb binaries - should not be needed
# sudo apt-get remove couchdb couchdb-bin couchdb-common -yf
apt-get install -V couchdb -y
# manage via upstart for Ubuntu 14.04 LTS
stop couchdb
# update /etc/couchdb/local.ini with 'bind_address=0.0.0.0' as needed
mv /etc/couchdb/local.ini /etc/couchdb/local.ini.bk
cp /vagrant/conf/couchdb/local.ini /etc/couchdb/
start couchdb
echo ">>>> couchdb listening on 5984"
