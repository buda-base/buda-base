if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ;
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
mkdir -p /etc/buda/share/geolite/
cd $DOWNLOADS
echo ">>>> setting up Geolite DB"
wget -q http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz
tar -xvzf GeoLite2-Country.tar.gz
cp */GeoLite2-Country.mmdb /etc/buda/share/geolite/GeoLite2-Country.mmdb
chmod 600 /etc/buda/share/geolite/GeoLite2-Country.mmdb 

#Config ldspdi
echo ">>>> setting up ldspdi config"
mkdir -p /etc/buda/ldspdi
cp /vagrant/conf/etc/buda/ldspdi/ldspdi-private.properties /etc/buda/ldspdi/
chown ldspdi:ldspdi /etc/buda/ldspdi/ldspdi-private.properties

#Config iiifserv
echo ">>>> setting up iiif server config"
mkdir -p /etc/buda/iiifserv
cp /vagrant/conf/etc/buda/iiifserv/application.yml /etc/buda/iiifserv/
cp /vagrant/conf/etc/buda/iiifserv/credentials /etc/buda/iiifserv/
cp /vagrant/conf/etc/buda/iiifserv/iiifserv-private.properties /etc/buda/iiifserv/

chown iiifserv:iiifserv /etc/buda/iiifserv/application.yml 
chown iiifserv:iiifserv /etc/buda/iiifserv/credentials
chown iiifserv:iiifserv /etc/buda/iiifserv/iiifserv-private.properties

#Config iiifpres
echo ">>>> setting up iiif presentation config"
mkdir -p /etc/buda/iiifpres
cp /vagrant/conf/etc/buda/iiifpres/credentials /etc/buda/iiifpres/
cp /vagrant/conf/etc/buda/iiifpres/iiifpres-private.properties /etc/buda/iiifpres/
 
chown iiifpres:iiifpres /etc/buda/iiifpres/credentials
chown iiifpres:iiifpres /etc/buda/iiifpres/iiifpres-private.properties

#Config blmp and pdl
echo ">>>> setting up pdl and blmp config"
mkdir -p /etc/buda/pdl
mkdir -p /etc/buda/blmp
cp /vagrant/conf/etc/buda/pdl/config.json /etc/buda/pdl/
cp /vagrant/conf/etc/buda/blmp/config.json /etc/buda/blmp/

echo ">>>> Buda services config was set"
