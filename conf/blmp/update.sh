#!/usr/bin/env bash

# this script updates a previous blmp install
# run via sudo

echo ">>>> updating blmp"

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

export ROOT="/root"
export PATH="$ROOT/.yarn/bin:$PATH"

echo ">>>> DATA_DIR: " $DATA_DIR

export BLMP_HOME=$DATA_DIR/blmp

cd $BLMP_HOME/blmp-client

echo ">>>> git pull"
git pull

echo ">>>> yarn install"
yarn -s --non-interactive install

echo ">>>> yarn build"
yarn -s --non-interactive build

echo ">>>> blmp update done"