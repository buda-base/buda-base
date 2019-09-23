#!/usr/bin/env bash

systemctl stop fuseki
systemctl stop marple

#general vars
echo ">>>> Updating Fuseki"
export TC_USER=fuseki
export TC_GROUP=fuseki
# set erb vars
# endpoint name for fuseki
export EP_NAME=core
export SVC=fuseki
export SVC_DESC="Jena-Fuseki Tomcat container"
export MARPLE_SVC=marple
export MARPLE_SVC_DESC="Marple service for fuseki Lucene indexes"
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
export LUCENE_BO_VER=1.5.0
export LUCENE_BO_JAR="lucene-bo-${LUCENE_BO_VER}.jar"
export LUCENE_BO_REL="https://github.com/buda-base/lucene-bo/releases/download/v${LUCENE_BO_VER}/${LUCENE_BO_JAR}"
export LUCENE_ZH_VER=0.4.1
export LUCENE_ZH_JAR="lucene-zh-${LUCENE_ZH_VER}.jar"
export LUCENE_ZH_REL="https://github.com/buda-base/lucene-zh/releases/download/v${LUCENE_ZH_VER}/${LUCENE_ZH_JAR}"
export LUCENE_SA_VER=1.1.0
export LUCENE_SA_JAR="lucene-sa-${LUCENE_SA_VER}.jar"
export LUCENE_SA_REL="https://github.com/buda-base/lucene-sa/releases/download/v${LUCENE_SA_VER}/${LUCENE_SA_JAR}"
export MARPLE_REL="https://github.com/flaxsearch/marple/releases/download/v1.0/marple-1.0.jar"
if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi
echo ">>>> DATA_DIR: " $DATA_DIR
export DOWNLOADS=$DATA_DIR/downloads
export THE_HOME=$DATA_DIR/$SVC
export THE_BASE=$THE_HOME/base
export CAT_HOME=$THE_HOME/tomcat

echo ">>>>>>>> updating {$EP_NAME}.ttl to {$THE_BASE}/configuration/"
erb /vagrant/conf/fuseki/ttl.erb > $THE_BASE/configuration/$EP_NAME.ttl

echo ">>>>>>>> updating qonsole-config.js to {$CAT_HOME}/webapps/fuseki/js/app/"
cp /vagrant/conf/fuseki/qonsole-config.js $CAT_HOME/webapps/fuseki/js/app/

echo ">>>>>>>> updating analyzers to {$CAT_HOME}/webapps/fuseki/WEB-INF/lib/"
# the lucene-bo jar has to be added to fuseki/WEB-INF/lib/ otherwise 
# tomcat class loading cannot find rest of Lucene classes
rm -f $CAT_HOME/webapps/fuseki/WEB-INF/lib/lucene-bo-*.jar
rm -f $CAT_HOME/webapps/fuseki/WEB-INF/lib/lucene-sa-*.jar
rm -f $CAT_HOME/webapps/fuseki/WEB-INF/lib/lucene-zh-*.jar
pushd $DOWNLOADS;
# wget -q -c $LUCENE_BO_REL
wget -q $LUCENE_BO_REL -O $LUCENE_BO_JAR
cp $LUCENE_BO_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
wget -q -c $LUCENE_ZH_REL
cp $LUCENE_ZH_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
wget -q -c $LUCENE_SA_REL
cp $LUCENE_SA_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
popd

echo ">>>> restarting ${SVC}"
systemctl start fuseki
systemctl start marple
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> Fuseki updating complete"
