apt-get install nginx openssl

if [ ! -f /etc/nginx/dhparam.pem ]; then
    openssl dhparam -out /etc/nginx/dhparam.pem 2048
fi

cp /vagrant/conf/nginx/ssl_params > /etc/nginx/ssl_params