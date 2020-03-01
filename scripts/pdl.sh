#!/usr/bin/env bash

echo ">>>> Installing pdl..."
export SVC_DESC=" BUDA Public Digital Library"
export TC_USER=pdl
export TC_GROUP=pdl
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export PDL=pdl
export PDLDEV=pdl-dev
export PDL_HOME=$DATA_DIR/$PDL
export PDLDEV_HOME=$DATA_DIR/$PDLDEV

# to use yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

mkdir -p $PDL_HOME

pushd $PDL_HOME

if [ ! -d $PDL_HOME/public-digital-library ] ; then 
  	echo ">>>> downloading & installing pdl"
	git clone https://github.com/buda-base/public-digital-library.git
	cd public-digital-library
	yarn -s --non-interactive install
	yarn -s --non-interactive build
fi

# adding update.sh script
cp /vagrant/conf/pdl/update.sh $PDL_HOME
chmod a+x $PDL_HOME/update.sh

echo ">>>> copying files to dev environment"
cp -R $PDL_HOME $PDLDEV_HOME