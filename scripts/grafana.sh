# install grafana
echo ">>>> installing Grafana server"

#general vars
echo ">>>> Installing iiif server"
export TC_USER=grafana
export TC_GROUP=grafana
export SVC=grafana
export SVC_DESC="Grafana monitoring UI"
export MAIN_PORT=14009
export GRAFANA_SITE=https://dl.grafana.com/oss/release
export GRAFANA_ARCHIVE=grafana-6.3.5.linux-amd64.tar.gz

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
useradd -s /bin/bash -g $TC_GROUP -d $THE_HOME $TC_USER

echo ">>>> checking grafana user and group"

id $TC_USER

echo ">>>> setting up grafana directories"

mkdir /etc/grafana
mkdir /etc/buda/monitoring/
mkdir /etc/buda/monitoring/grafana
mkdir /var/lib/grafana
mkdir $DATA_DIR/$SVC

echo ">>>> downloading grafana"

cd $DATA_DIR/$SVC

wget -q $GRAFANA_SITE/$GRAFANA_ARCHIVE
tar -zxvf $GRAFANA_ARCHIVE

echo ">>>> fixing permissions"
chown -R $TC_USER:$TC_GROUP $THE_HOME

mv grafana-6.3.5 grafana

echo ">>>> setting up ${SVC} as service listening on ${MAIN_PORT}"
chown grafana:grafana /etc/grafana
chown grafana:grafana /etc/buda/monitoring/grafana
chown grafana:grafana /var/lib/grafana
chown grafana:grafana $DATA_DIR/$SVC
chown -R grafana:grafana $THE_HOME/grafana/conf

mv $THE_HOME/grafana/conf/defaults.ini $THE_HOME/grafana/conf/defaults.ini.back
erb /vagrant/conf/grafana/defaults.ini.erb > $THE_HOME/grafana/conf/defaults.ini
erb /vagrant/conf/grafana/systemd.erb > /etc/systemd/system/$SVC.service

chown -R grafana:grafana $THE_HOME/grafana/conf

echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> grafana provisioning complete"