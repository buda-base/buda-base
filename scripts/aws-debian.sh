#!/usr/bin/env bash

# add ssh port on 15345
echo ">>>> adding ssh port on 15345"
cp /vagrant/conf/debian/sshd_config /etc/ssh/
systemctl restart sshd
