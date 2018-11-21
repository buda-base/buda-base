#!/usr/bin/env bash

echo ">>>> installing open jdk, may take some time"
echo ">>>> update packages"
apt-get update -y -qq
echo ">>>> installing default-jdk"
apt-get install default-jdk -y -qq
echo ">>>> open jdk install done"
