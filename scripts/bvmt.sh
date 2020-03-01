#!/usr/bin/env bash

echo ">>>> Installing bvmt..."
export SVC_DESC="BUDA Volume Manifest Tool"
export TC_USER=bvmt
export TC_GROUP=bvmt
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export BVMT=bvmt
export BVMTDEV=bvmt-dev
export BVMT_HOME=$DATA_DIR/$BVMT
export BVMTDEV_HOME=$DATA_DIR/$BVMTDEV

# to use yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

mkdir -p $BVMT_HOME

pushd $BVMT_HOME

if [ ! -d $BVMT_HOME/buda-volume-manifest-tool ] ; then 
  	echo ">>>> downloading & installing pdl"
	git clone https://github.com/buda-base/buda-volume-manifest-tool.git
	cd buda-volume-manifest-tool
	yarn -s --non-interactive install
	yarn -s --non-interactive build
fi

# adding update.sh script
cp /vagrant/conf/bvmt/update.sh $BVMT_HOME
chmod a+x $BVMT_HOME/update.sh

echo ">>>> copying files to dev environment"
cp -R $BVMT_HOME $BVMTDEV_HOME