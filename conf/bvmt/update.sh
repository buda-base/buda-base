#!/usr/bin/env bash

# this script updates a previous bvmt install
# run via sudo

echo ">>>> updating bvmt"

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

export ROOT="/root"
export PATH="$ROOT/.yarn/bin:$PATH"

echo ">>>> DATA_DIR: " $DATA_DIR

export BVMT_HOME=$DATA_DIR/bvmt

cd $PDL_HOME/buda-volume-manifest-tool

echo ">>>> git pull"
git pull

echo ">>>> yarn install"
yarn -s --non-interactive install

echo ">>>> yarn build"
yarn -s --non-interactive build

echo ">>>> bvmt update done"