#!/usr/bin/env bash

# this script updates a previous pdl install
# run via sudo

echo ">>>> updating pdl"

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

export ROOT="/root"
export PATH="$ROOT/.yarn/bin:$PATH"

echo ">>>> DATA_DIR: " $DATA_DIR

export PDL_HOME=$DATA_DIR/pdl

cd $PDL_HOME/public-digital-library

echo ">>>> git pull"
git pull

echo ">>>> yarn install"
yarn install

echo ">>>> yarn build"
yarn build

echo ">>>> pdl update done"