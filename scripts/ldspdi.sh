#!/usr/bin/env bash

echo ">>>> Installing lds-pdi application..."
export SVC_DESC="Linked Data Service - Public Data Interface container"
export SVC=ldspdi
export TC_USER=ldspdi
export TC_GROUP=ldspdi

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ;
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`

export THE_HOME=$DATA_DIR/$LDSPDI
export MAIN_PORT=13280
export MAX_MEM="-Xmx4096M"

export EXECFILE=lds-pdi-exec.war

mkdir -p $CAT_HOME

# add Service USER
echo ">>>> adding user: ${TC_USER}"
groupadd $TC_GROUP
# useradd -s /bin/false -g $TC_GROUP -d $THE_HOME $TC_USER
# during development let the user login
useradd -s /bin/bash -g $TC_GROUP -d $LDSPDI_HOME $TC_USER

cp /vagrant/conf/lds-pdi/update.sh $LDSPDI_HOME/
chmod u+x $LDSPDI_HOME/update.sh

echo ">>>> cloning ldspdi"
mkdir -p $DOWNLOADS
mkdir -p $THE_HOME

# install ldspdi
echo ">>>> installing ldspdi server"
rm -rf --preserve-root $DOWNLOADS/lds-pdi
pushd $DOWNLOADS;
git clone https://github.com/buda-base/lds-pdi.git
cd lds-pdi
if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi

mvn -B clean package -Dldspdi.configpath=/etc/buda/ldspdi/ -Dspring.profiles.active=PROD -DskipTests -Dmaven.test.skip=true

chown $TC_USER:$TC_GROUP target/*.war
cp target/*-exec.war $THE_HOME/lds-pdi-exec.war

popd

# setup as Debian systemctl service listening on $MAIN_PORT
echo ">>>> setting up ${SVC} as service listening on ${MAIN_PORT}"
erb /vagrant/conf/tomcat/systemd.erb > /etc/systemd/system/$SVC.service
echo ">>>> starting ${SVC} service"
systemctl daemon-reload
systemctl enable $SVC
systemctl start $SVC

echo ">>>> lds-pdi application installed ..."
