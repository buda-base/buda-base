#!/usr/bin/env bash

#general vars
echo ">>>> Installing iiif server"
export TC_USER=prometheus
export TC_GROUP=prometheus
export SVC=prometheus
export SVC_DESC="Prometheus monitoring Server"


if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC
export PROMETHEUS="Prometheus monitoring Server"
export MAIN_PORT=13999
export CONF_DIR=/etc/buda/monitoring/prometheus

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
useradd -s /bin/bash -g $TC_GROUP -d $THE_HOME $TC_USER

# place to download non apt-get items
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install prometheus
echo ">>>> installing Prometheus server"
cd $DOWNLOADS;
wget https://github.com/prometheus/prometheus/releases/download/v2.12.0/prometheus-2.12.0.linux-amd64.tar.gz
tar -xzf prometheus-2.12.0.linux-amd64.tar.gz

echo ">>>> setting up prometheus directories"

mkdir /etc/prometheus
mkdir /etc/buda/monitoring
mkdir /etc/buda/monitoring/prometheus
mkdir /var/lib/prometheus

chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /etc/buda/monitoring/prometheus
chown prometheus:prometheus /var/lib/prometheus

echo ">>>> install prometheus files"

cp prometheus-2.12.0.linux-amd64/prometheus /usr/local/bin/
cp prometheus-2.12.0.linux-amd64/promtool /usr/local/bin/

chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

cp -r prometheus-2.12.0.linux-amd64/consoles /etc/prometheus/
cp -r prometheus-2.12.0.linux-amd64/console_libraries/ /etc/prometheus/

chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_librarie

echo ">>>> copying default prometheus config file"

cp /vagrant/conf/prometheus/prometheus.yml $CONF_DIR

echo ">>>> fixing permissions"
chown -R $TC_USER:$TC_GROUP $THE_HOME

echo ">>>> setting up ${SVC} as service listening on ${MAIN_PORT}"
erb /vagrant/conf/prometheus/systemd.erb > /etc/systemd/system/$SVC.service

echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> prometheus provisioning complete"