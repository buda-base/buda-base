#!/usr/bin/env bash

# install Node.js; npm; and n
echo ">>>> installing node.js; npm; and n"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get install -y nodejs build-essential
npm install -g n
# install node.js i/f to couchdb -
# see https://www.npmjs.com/package/node-couch
# npm install -g node-couch
# to update node.js use
# sudo npm cache clean -f
# sudo n stable

curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
