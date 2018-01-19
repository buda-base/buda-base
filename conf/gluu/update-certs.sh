#!/usr/bin/env bash

export DATE=`date +"%Y%m%d"`
export GLUU=/opt/gluu-server-3.1.1
export LIVE=/etc/letsencrypt/live/budauth.bdrc.io/

mkdir -p ~/certs-backup
sudo tar -czf ~/certs-backup/certs-$DATE.tar.gz  $GLUU/etc/certs $GLUU/opt/jdk1.8.0_112/jre/lib/security/cacerts
sudo chown ubuntu:ubuntu ~/certs-backup/certs-$DATE.tar.gz


sudo cp /etc/letsencrypt/live/budauth.bdrc.io/privkey.pem $GLUU/etc/certs/httpd.key
sudo cp /etc/letsencrypt/live/budauth.bdrc.io/fullchain.pem $GLUU/etc/certs/httpd.crt

sudo service gluu-server-3.1.1 login

cd /etc/certs

openssl x509 -outform der -in httpd.crt -out httpd.der

/opt/jre/jre/bin/keytool -delete -alias budauth.bdrc.io_httpd -keystore /opt/jre/jre/lib/security/cacerts -storepass changeit
/opt/jre/jre/bin/keytool -importcert -file httpd.der -keystore /opt/jre/jre/lib/security/cacerts -alias budauth.bdrc.io_httpd -noprompt -storepass changeit

service solserver stop
service apache2 stop
service oxauth stop
service oxauth-rp stop
service identity stop


service solserver start
service apache2 start
service oxauth start
service oxauth-rp start
service identity start
