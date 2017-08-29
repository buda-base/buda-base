#!/bin/bash

echo ">>>> installing couchdb-lucene."

export REL="https://github.com/BuddhistDigitalResourceCenter/couchdb-lucene/releases/download/2.1.0/couchdb-lucene-2.1.0-dist.tar.gz"
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR

if [ -a $DATA_DIR/couchdb-lucene/bin/run ]; then
   	echo ">>>> couchdb-lucene present. Skipping couchdb-lucene download."
else
   	echo ">>>> downloading couchdb-lucene."
	cd $DATA_DIR
	mkdir couchdb-lucene
#	curl -fSLs $REL -o couchdb-lucene.tar.gz
# until Newson decides to put up a release or some other agreeable location is found
# the couchdb-lucene is sequestered here for use.
	cp /vagrant/conf/couchdb-lucene/couchdb-lucene-2.2.0-SNAPSHOT-dist.tar.gz couchdb-lucene.tar.gz
	tar -xzf couchdb-lucene.tar.gz -C couchdb-lucene --strip-components=1
	rm couchdb-lucene.tar.gz
fi

# configure

cd $DATA_DIR/couchdb-lucene
cp /vagrant/conf/couchdb-lucene/couchdb-lucene.ini conf/
chown -R couchdb:couchdb $DATA_DIR/couchdb-lucene

erb /vagrant/conf/couchdb-lucene/couchdb-lucene.service.erb > /etc/systemd/system/couchdb-lucene.service
systemctl daemon-reload
systemctl enable couchdb-lucene
systemctl start couchdb-lucene

echo ">>>> couchdb-lucene listening on 13599."
