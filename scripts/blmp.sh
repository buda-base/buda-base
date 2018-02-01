
echo ">>>> Installing blmp..."
export SVC_DESC=" BUDA Library Management Portal"
export TC_USER=blmp
export TC_GROUP=blmp
export DATA_DIR=/usr/local ;

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export BLMP=blmp
export BLMP_HOME=$DATA_DIR/$BLMP

mkdir -p $BLMP_HOME

echo ">>>> installing node & yarn"

curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs

curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

echo ">>>> downloading owl-schema"
git clone https://github.com/BuddhistDigitalResourceCenter/owl-schema.git

echo ">>>> downloading & installing blmp-prototype_flow"

pushd $BLMP_HOME
git clone https://github.com/BuddhistDigitalResourceCenter/blmp-prototype-flow.git
cd blmp-prototype-flow
yarn install

echo ">>>> starting react server"
nohup yarn start &
