#!/usr/bin/env bash

# install Node.js; npm; and n
if [ $(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo ">>>> installing node.js; npm; and n"
	curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
	apt-get install -y nodejs build-essential
	npm install -g n
	curl -o- -L https://yarnpkg.com/install.sh | bash
	export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi
