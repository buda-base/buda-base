#!/usr/bin/env bash

# set erb vars
echo ">>>> Updating Fuseki ttl config"
export SVC=fuseki
# endpoint name for fuseki
export EP_NAME=core

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR

export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC
export THE_BASE=$THE_HOME/base

export THE_BASE=$THE_HOME/base
export LUCENE_INDEX=lucene-$EP_NAME

echo ">>>>>>>> updating {$EP_NAME}.ttl to {$THE_BASE}/configuration/"
erb /vagrant/conf/fuseki/ttl.erb > $THE_BASE/configuration/$EP_NAME.ttl
