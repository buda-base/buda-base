#!/usr/bin/env bash

#general vars
echo ">>>> home: ${HOME}"
export DOWNLOADS=$HOME/downloads
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
export CAT_HOME=/var/lib/tomcat8
export SHUTDOWN_PORT=13105
export MAIN_PORT=13180
export REDIR_PORT=13143
export AJP_PORT=13109
# install tomcat container
apt install -y tomcat8 maven
# configure server
echo ">>>> configuring server.xml tomcat 8"
erb /vagrant/conf/tomcat/server.xml.erb > $CAT_HOME/conf/server.xml
# enable tomcat admin and manager apps
cp  /vagrant/conf/tomcat/tomcat-users.xml $CAT_HOME/conf/
echo ">>>> downloading jena 2.5"
wget -q -c http://apache.mindstudios.com/jena/binaries/apache-jena-fuseki-2.5.0.tar.gz
tar xf apache-jena-fuseki-2.5.0.tar.gz
cp apache-jena-fuseki-2.5.0/fuseki.war $CAT_HOME/webapps/fuseki.war
chown -R :tomcat8 /usr/local/fuseki/base/
chmod -R g+w /usr/local/fuseki/base/
echo ">>>> restarting tomcat"
systemctl restart tomcat8