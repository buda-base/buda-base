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
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz
tar -xvzf GeoLite2-Country.tar.gz
cp */GeoLite2-Country.mmdb /etc/buda/share/geolite/GeoLite2-Country.mmdb
chmod 600 /etc/buda/share/geolite/GeoLite2-Country.mmdb 

