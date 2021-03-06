#!/usr/bin/env bash

# install Node.js; npm; and n
if [ $(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo ">>>> installing node.js; npm; and n"
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	apt-get update -qq
	apt-get install -y -qq nodejs build-essential yarn
	npm install -g n
fi
