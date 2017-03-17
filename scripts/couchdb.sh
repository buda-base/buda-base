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

echo ">>>> so relaxed now, let's create the database and upload the design document"

curl -s -X PUT http://localhost:13598/test
curl -s -X PUT http://localhost:13598/test/_design/jsonld -d @/vagrant/conf/couchdb/design-jsonld.json