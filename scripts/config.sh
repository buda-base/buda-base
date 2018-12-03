echo ">>>> setting up Geolite DB"
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz
tar -xvzf GeoLite2-Country.tar.gz
cp */GeoLite2-Country.mmdb /etc/buda/share/geolite/GeoLite2-Country.mmdb

