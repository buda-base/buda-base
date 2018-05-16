#!/usr/bin/env bash

#general vars
echo ">>>> Updating Fuseki"
export TC_USER=fuseki
export TC_GROUP=fuseki
export TC_REL="http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.42/bin/apache-tomcat-8.0.42.tar.gz"
# set erb vars
# endpoint name for fuseki
export EP_NAME=bdrc
export SVC=fuseki
export SVC_DESC="Jena-Fuseki Tomcat container"
export MARPLE_SVC=marple
export MARPLE_SVC_DESC="Marple service for fuseki Lucene indexes"
export JAVA_HOME=`type -p javac|xargs readlink -f|xargs dirname|xargs dirname`
# export FUSEKI_REL="https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-3.6.0.tar.gz"
# export FUSEKI_DIR="apache-jena-fuseki-3.6.0"
export FUSEKI_ZIP="https://github.com/BuddhistDigitalResourceCenter/jena/releases/download/v3.7.0-HiLiting/jena-fuseki-war-3.7.0-SNAPSHOT.war.zip"
export FUSEKI_WAR="jena-fuseki-war-3.7.0-SNAPSHOT.war"
export LUCENE_BO_VER=1.3.0
export LUCENE_BO_JAR="lucene-bo-${LUCENE_BO_VER}.jar"
export LUCENE_BO_REL="https://github.com/BuddhistDigitalResourceCenter/lucene-bo/releases/download/v${LUCENE_BO_VER}/${LUCENE_BO_JAR}"
export LUCENE_ZH_VER=0.2.0
export LUCENE_ZH_JAR="lucene-zh-${LUCENE_ZH_VER}.jar"
export LUCENE_ZH_REL="https://github.com/BuddhistDigitalResourceCenter/lucene-zh/releases/download/v${LUCENE_ZH_VER}/${LUCENE_ZH_JAR}"
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
export SHUTDOWN_PORT=13105
export MAIN_PORT=13180
export REDIR_PORT=13143
export AJP_PORT=13109
export MAX_MEM="-Xmx4096M"
export LUCENE_INDEX=lucene-$EP_NAME
export MARPLE_APP_PORT=13190
export MARPLE_ADM_PORT=13191
export MARPLE_JAR=marple-1.0.jar
export MARPLE_HOME=$THE_HOME/marple

echo ">>>>>>>> updating bdrc.ttl to {$THE_BASE}/configuration/"
erb /vagrant/conf/fuseki/ttl.erb > $THE_BASE/configuration/bdrc.ttl

echo ">>>>>>>> updating qonsole-config.js to {$CAT_HOME}/webapps/fuseki/js/app/"
cp /vagrant/conf/fuseki/qonsole-config.js $CAT_HOME/webapps/fuseki/js/app/

echo ">>>>>>>> updating ${LUCENE_BO_JAR} and ${LUCENE_ZH_JAR} to {$CAT_HOME}/webapps/fuseki/WEB-INF/lib/"
# the lucene-bo jar has to be added to fuseki/WEB-INF/lib/ otherwise 
# tomcat class loading cannot find rest of Lucene classes
pushd $DOWNLOADS;
wget -q -c $LUCENE_BO_REL
cp $LUCENE_BO_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
wget -q -c $LUCENE_ZH_REL
cp $LUCENE_ZH_JAR $CAT_HOME/webapps/fuseki/WEB-INF/lib/
popd

echo ">>>> restarting ${SVC}"
systemctl restart $SVC
echo ">>>> ${SVC} service listening on ${MAIN_PORT}"

echo ">>>> Fuseki updating complete"
