#!/usr/bin/env bash

# install RabbitMQ
echo ">>>> installing RabbitMQ and cients"
apt-get install rabbitmq-server -y
apt-get install amqp-tools -y
npm install rabbit.js
