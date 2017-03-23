#!/usr/bin/env bash

export SVC=fuseki
export SVC_DESC="Jena-Fuseki Tomcat container"
export THE_HOME=/usr/local/$SVC
systemctl stop $SVC
echo ">>>> patching ${SVC} query console configuration"
# patching ${SVC} query console configuration and restart
cp /vagrant/conf/fuseki/qonsole-config.js $THE_HOME/tomcat/webapps/fuseki/js/app/
systemctl start $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"
