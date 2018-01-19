#!/usr/bin/env bash

# from https://gluu.org/docs/ce/installation-guide/install/
echo ">>>> installing gluu"

echo "deb https://repo.gluu.org/ubuntu/ xenial main" | sudo cat - > /etc/apt/sources.list.d/gluu-repo.list

curl https://repo.gluu.org/ubuntu/gluu-apt.key | apt-key add -

apt-get install apt-transport-https

apt-get update

apt-get install gluu-server-3.1.1

echo ">>>> gluu installed"
echo ">>>> Log in to the server and complete the install via:"
echo ">>>> sudo service glu-server-3.1.1 start"
echo ">>>> sudo service glu-server-3.1.1 login"
echo ">>>> cd /install/community-edition-setup"
echo ">>>> ./setup.py"
