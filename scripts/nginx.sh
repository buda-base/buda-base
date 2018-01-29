#!/usr/bin/env bash

echo ">>>> Installing Nginx and Openssl"

apt-get install nginx openssl

if [ ! -f /etc/nginx/dhparam.pem ]; then
    openssl dhparam -out /etc/nginx/dhparam.pem 2048
fi

cp /vagrant/conf/nginx/ssl_params > /etc/nginx/ssl_params

echo ">>>> set up default config: port 80 to ldspdi
# rm the link to /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
cp /vagrant/conf/nginx/default /etc/nginx/sites-enabled/

sudo systemctl enable nginx

sudo systemctl restart nginx

echo ">>>> Nginx Installed"
