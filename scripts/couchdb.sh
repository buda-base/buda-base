#!/bin/bash

# partly from https://gist.github.com/mrded/280433eef0986a112f0393ccfc97b7c8
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/opt ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR

if [ -a $DATA_DIR/couchdb/bin/couchdb ]; then
   	echo "skip couchdb installation"
else
	# Add CouchDB user account
	groupadd -r couchdb && useradd -d $DATA_DIR/couchdb -g couchdb -r -s /bin/false couchdb

	apt-get update -y
	apt-get install -y --no-install-recommends ca-certificates curl haproxy erlang-nox erlang-reltool libicu57 libmozjs185-1.0 openssl

	# Download dev dependencies
	apt-get update -y -qq && apt-get install -y --no-install-recommends apt-transport-https build-essential erlang-dev libcurl4-openssl-dev libicu-dev libmozjs185-dev
	npm install -g grunt-cli

	# Acquire CouchDB source code
	cd /usr/src
	mkdir couchdb
	curl -fSLs https://dist.apache.org/repos/dist/release/couchdb/source/2.1.0/apache-couchdb-2.1.0.tar.gz -o couchdb.tar.gz
	tar -xzf couchdb.tar.gz -C couchdb --strip-components=1
	cd couchdb

	# Build the release and install into $DATA_DIR
	./configure --disable-docs
	make release
	mv /usr/src/couchdb/rel/couchdb $DATA_DIR/

	mv $DATA_DIR/couchdb/etc/local.ini $DATA_DIR/couchdb/etc/local.ini.bk
	chown -R couchdb:couchdb $DATA_DIR/couchdb

	 # Cleanup build detritus
	rm -rf /usr/src/couchdb
fi


erb /vagrant/conf/couchdb/local.ini.erb > $DATA_DIR/couchdb/etc/local.ini
chown -R couchdb:couchdb $DATA_DIR/couchdb/etc/local.ini

erb /vagrant/conf/couchdb/couchdb.service.erb > /lib/systemd/system/couchdb.service
systemctl daemon-reload
systemctl enable couchdb
systemctl start couchdb

echo ">>>> couchdb listening, sleeping on the couch a little bit..."

sleep 2

echo ">>>> create system databases."

curl -s -X PUT http://localhost:13598/_users
curl -s -X PUT http://localhost:13598/_replicator
curl -s -X PUT http://localhost:13598/_global_changes

echo ">>>> so relaxed now, let's create the databases and upload design documents."

curl -s -X PUT http://localhost:13598/bdrc_corporation
curl -s -X PUT http://localhost:13598/bdrc_corporation/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_lineage
curl -s -X PUT http://localhost:13598/bdrc_lineage/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_office
curl -s -X PUT http://localhost:13598/bdrc_office/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_outline
curl -s -X PUT http://localhost:13598/bdrc_outline/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_person
curl -s -X PUT http://localhost:13598/bdrc_person/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_place
curl -s -X PUT http://localhost:13598/bdrc_place/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_topic
curl -s -X PUT http://localhost:13598/bdrc_topic/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_items
curl -s -X PUT http://localhost:13598/bdrc_items/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_work
curl -s -X PUT http://localhost:13598/bdrc_work/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/test
curl -s -X PUT http://localhost:13598/test/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json

echo ">>>> initial databases created with design documents."
