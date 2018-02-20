#!/usr/bin/env bash

echo ">>>> Installing Nginx and Openssl"

apt-get install nginx openssl -y

if [ ! -f /etc/nginx/dhparam.pem ]; then
	echo ">>>> create key (may take some time)"
    openssl dhparam -out /etc/nginx/dhparam.pem 2048 2> /dev/null
fi

cp /vagrant/conf/nginx/ssl_params /etc/nginx/ssl_params
cp /vagrant/conf/nginx/acmechallenge.conf /etc/nginx/

echo ">>>> set up nginx"
# rm the link to /etc/nginx/sites-available/default
rm -f /etc/nginx/sites-enabled/default

if [ -d /mnt/data ] ; then 
  cp /vagrant/conf/nginx/local.conf /etc/nginx/sites-enabled/
else
  cp /vagrant/conf/nginx/aws.conf /etc/nginx/sites-enabled/
fi

sudo systemctl enable nginx

sudo systemctl restart nginx

echo ">>>> Nginx Installed"
