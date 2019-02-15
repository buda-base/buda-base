if [ $(dpkg-query -W -f='${Status}' python-certbot-nginx 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
	apt-get update -q
	apt-get install python-certbot-nginx -t stretch-backports -y -q
fi

mkdir -p /var/www/letsencrypt

crontab -l | { cat; echo "0 12 * * * /usr/bin/certbot renew --quiet"; } | crontab -

# procedure:
# certbot certonly -d iiif.bdrc.io --webroot --agree-tos -m github@tbrc.org -w /var/www/letsencrypt
# uncomment the ssl part of iiif.bdrc.io in /etc/nginx/sites-available/aws.conf