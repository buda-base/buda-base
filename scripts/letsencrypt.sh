if [ $(dpkg-query -W -f='${Status}' python-certbot-nginx 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
	apt-get update
	apt-get install python-certbot-nginx -t stretch-backports -y
fi

mkdir -p /var/www/letsencrypt

crontab -l | { cat; echo "0 12 * * * /usr/bin/certbot renew --quiet"; } | crontab -