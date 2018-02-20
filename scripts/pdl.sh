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
export BLMP=pdl
export BLMP_HOME=$DATA_DIR/$BLMP

# to use yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

mkdir -p $BLMP_HOME

pushd $BLMP_HOME

if [ ! -d $BLMP_HOME/blmp-prototype-flow ] ; then 
  	echo ">>>> downloading & installing blmp-prototype_flow"
	git clone https://github.com/BuddhistDigitalResourceCenter/public-digital-library.git
	cd public-digital-library
	yarn install
	yarn build
fi

# adding update.sh script
cp /vagrant/conf/pdl/update.sh $BLMP_HOME
chmod a+x $BLMP_HOME/update.sh
