#!/usr/bin/env bash

echo ">>>> Updating ldspdi server"
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
export TC_USER=ldspdi
export TC_GROUP=ldspdi
export SVC=ldspdi
export DOWNLOADS="$DATA_DIR/downloads"
export LDSPDI="ldspdi"
export THE_HOME=$DATA_DIR/$SVC

service ldspdi stop

echo ">>>> cloning ldspdi"
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install ldspdi
echo ">>>> installing ldspdi server"
rm -rf --preserve-root $DOWNLOADS/lds-pdi
pushd $DOWNLOADS;

git clone https://github.com/buda-base/lds-pdi.git

cd lds-pdi
if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi

mvn -B clean package -Dldspdi.configpath=/etc/buda/$SVC/ -Dspring.profiles.active=PROD -DskipTests -Dmaven.test.skip=true

chown $TC_USER:$TC_GROUP target/*.war
chown -R $TC_USER:$TC_GROUP $THE_HOME

cp target/*-exec.war $THE_HOME/lds-pdi-exec.war

popd

pushd $THE_HOME;

if [ -d owl-schema ]
then
  cd owl-schema
  git pull
  cd ..
else
  git clone https://github.com/buda-base/owl-schema.git
fi

if [ -d editor-templates ]
then
  cd editor-templates
  git pull
  cd ..
else
  git clone https://github.com/buda-base/editor-templates.git
fi

if [ -d lds-queries ]
then
  cd lds-queries
  git pull
  cd ..
else
  git clone https://github.com/buda-base/lds-queries.git
fi

chown -R $TC_USER:$TC_GROUP owl-schema
chown -R $TC_USER:$TC_GROUP editor-templates
chown -R $TC_USER:$TC_GROUP lds-queries

popd

service $SVC start

echo ">>>> ldspdi was updated"
