#!/usr/bin/env bash

echo ">>>> Installing blmp..."
export SVC_DESC=" BUDA Library Management Portal"
export TC_USER=blmp
export TC_GROUP=blmp
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export BLMP=blmp
export BLMP_HOME=$DATA_DIR/$BLMP

# to use yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

mkdir -p $BLMP_HOME

pushd $BLMP_HOME

if [ ! -d $BLMP_HOME/blmp-prototype-flow ] ; then 
	echo ">>>> downloading owl-schema"
	git clone https://github.com/buda-base/owl-schema.git
  	echo ">>>> downloading & installing blmp-prototype_flow"
	git clone https://github.com/buda-base/blmp-prototype-flow.git
	cd blmp-prototype-flow
	yarn -s --non-interactive install
	yarn -s --non-interactive build
fi

# adding update.sh script
cp /vagrant/conf/blmp/update.sh $BLMP_HOME
chmod a+x $BLMP_HOME/update.sh
