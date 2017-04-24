#!/bin/bash

echo ">>>> installing couchdb-lucene."

export REL="https://github.com/BuddhistDigitalResourceCenter/couchdb-lucene/releases/download/v2.1.0_bdrc/couchdb-lucene-2.1.0_bdrc-dist.tar.gz"

if [ -a /usr/local/couchdb-lucene/bin/run ]; then
   	echo ">>>> couchdb-lucene present. Skipping couchdb-lucene download."
else
   	echo ">>>> downloading couchdb-lucene."
	cd /usr/local/
	mkdir couchdb-lucene
	curl -fSLs $REL -o couchdb-lucene.tar.gz
	tar -xzf couchdb-lucene.tar.gz -C couchdb-lucene --strip-components=1
	rm couchdb-lucene.tar.gz
fi

# configure

cd /usr/local/couchdb-lucene
cp /vagrant/conf/couchdb-lucene/couchdb-lucene.ini ./conf/
chown -R couchdb:couchdb /usr/local/couchdb-lucene

cp /vagrant/conf/couchdb-lucene/couchdb-lucene.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable couchdb-lucene
systemctl start couchdb-lucene

echo ">>>> couchdb-lucene listening on 13599."
