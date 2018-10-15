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
export PDL_HOME=$DATA_DIR/$PDL

# to use yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

mkdir -p $PDL_HOME

pushd $PDL_HOME

if [ ! -d $PDL_HOME/blmp-prototype-flow ] ; then 
  	echo ">>>> downloading & installing pdl"
	git clone https://github.com/BuddhistDigitalResourceCenter/public-digital-library.git
	cd public-digital-library
	yarn -s --non-interactive install
	yarn -s --non-interactive build
fi

# adding update.sh script
cp /vagrant/conf/pdl/update.sh $PDL_HOME
chmod a+x $PDL_HOME/update.sh
