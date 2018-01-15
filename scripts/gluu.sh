#!/usr/bin/env bash

# from https://gluu.org/docs/ce/installation-guide/install/
echo ">>>> installing gluu"

echo "deb https://repo.gluu.org/debian/ stable main" | sudo cat - > /etc/apt/sources.list.d/gluu-repo.list

curl https://repo.gluu.org/debian/gluu-apt.key | apt-key add -

apt-get install apt-transport-https

apt-get update

apt-get install gluu-server-3.1.1

echo ">>>> gluu installed"