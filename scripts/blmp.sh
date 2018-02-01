
echo ">>>> Installing blmp..."
export SVC_DESC=" BUDA Library Management Portal"
export TC_USER=blmp
export TC_GROUP=blmp
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
  export ON_AWS=yes ;
fi

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export BLMP=blmp
export BLMP_HOME=$DATA_DIR/$BLMP

# to use yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

mkdir -p $BLMP_HOME
pushd $BLMP_HOME

echo ">>>> downloading owl-schema"
git clone https://github.com/BuddhistDigitalResourceCenter/owl-schema.git

echo ">>>> downloading & installing blmp-prototype_flow"
if $ON_AWS then
    echo ">>>> should be installing blmp in nginx" ;
else
	git clone https://github.com/BuddhistDigitalResourceCenter/blmp-prototype-flow.git
	ls -l blmp* owl*
	cd blmp-prototype-flow
	ls -l public
	yarn install
	yarn build
fi