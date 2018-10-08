#!/usr/bin/env bash

echo ">>>> installing open jdk, may take some time"
apt-get update -q
apt-get install default-jdk -y -q
echo ">>>> open jdk install done"
