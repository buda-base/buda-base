#!/usr/bin/env bash

echo ">>>> installing githubmail"

if [ -d /mnt/data ] ; then 
  export DATA_DIR=/mnt/data ; 
else
  export DATA_DIR=/usr/local ;
fi

export DOWNLOADS="$DATA_DIR/downloads"
export GITHUBMAIL="githubmail"
export GITHUBMAIL_HOME="$DATA_DIR/$GITHUBMAIL"

service iiifpres stop

echo ">>>> cloning githubmail"
mkdir -p $DOWNLOADS/$GITHUBMAIL
pushd $DOWNLOADS/$GITHUBMAIL

rm -rf --preserve-root tmpgitgithubmail
git clone https://github.com/buda-base/github-mail.git tmpgitgithubmail
pushd tmpgitgithubmail
if [ "$#" -eq 1 ]; then
    git checkout "$1"
fi
mvn -B clean package
chown gitmail:gitmail target/*.war
rm -rf --preserve-root $GITHUBMAIL_HOME/tomcat/webapps/ROOT
mv target/*.war $GITHUBMAIL_HOME/tomcat/webapps/ROOT.war
popd
rm -rf --preserve-root tmpgitgithubmail

service githubmail start

echo ">>>> githubmail installed"
