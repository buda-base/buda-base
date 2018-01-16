#!/usr/bin/env bash

echo ">>>> additional installs for debian on AWS"
apt-get install lsof -y

# add ssh port on 15345
echo ">>>> adding ssh port on 15345"
cp /vagrant/conf/ubuntu/sshd_config /etc/ssh/
systemctl restart sshd
