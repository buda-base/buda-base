#!/bin/bash

# partly from https://gist.github.com/mrded/280433eef0986a112f0393ccfc97b7c8

if [ -a /opt/couchdb/bin/couchdb ]; then
   	echo "skip couchdb installation"
else
	# Add CouchDB user account
	groupadd -r couchdb && useradd -d /opt/couchdb -g couchdb -r -s /bin/false couchdb

	apt-get update -y
	apt-get install -y --no-install-recommends ca-certificates curl haproxy erlang-nox erlang-reltool libicu52 libmozjs185-1.0 openssl

	# Download dev dependencies
	apt-get update -y -qq && apt-get install -y --no-install-recommends apt-transport-https build-essential erlang-dev libcurl4-openssl-dev libicu-dev libmozjs185-dev
	npm install -g grunt-cli

	# Acquire CouchDB source code
	cd /usr/src
	mkdir couchdb
	curl -fSLs https://dist.apache.org/repos/dist/release/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz -o couchdb.tar.gz
	tar -xzf couchdb.tar.gz -C couchdb --strip-components=1
	cd couchdb

	# Build the release and install into /opt
	./configure --disable-docs
	make release
	mv /usr/src/couchdb/rel/couchdb /opt/

	mv /opt/couchdb/etc/local.ini /opt/couchdb/etc/local.ini.bk
	chown -R couchdb:couchdb /opt/couchdb

	 # Cleanup build detritus
	rm -rf /usr/src/couchdb
fi


cp /vagrant/conf/couchdb/local.ini /opt/couchdb/etc/
chown -R couchdb:couchdb /opt/couchdb/etc/local.ini

cp /vagrant/conf/couchdb/couchdb.service /lib/systemd/system/
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

curl -s -X PUT http://localhost:13598/bdrc_corporations
curl -s -X PUT http://localhost:13598/bdrc_corporations/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_lineages
curl -s -X PUT http://localhost:13598/bdrc_lineages/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_offices
curl -s -X PUT http://localhost:13598/bdrc_offices/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_outlines
curl -s -X PUT http://localhost:13598/bdrc_outlines/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_persons
curl -s -X PUT http://localhost:13598/bdrc_persons/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_places
curl -s -X PUT http://localhost:13598/bdrc_places/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_topics
curl -s -X PUT http://localhost:13598/bdrc_topics/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_volumes
curl -s -X PUT http://localhost:13598/bdrc_volumes/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/bdrc_works
curl -s -X PUT http://localhost:13598/bdrc_works/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json
curl -s -X PUT http://localhost:13598/test
curl -s -X PUT http://localhost:13598/test/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json

echo ">>>> initial databases created with design documents."
