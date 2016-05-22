#!/usr/bin/env bash

# install RabbitMQ
echo ">>>> installing RabbitMQ and cients"
sudo apt-get install rabbitmq-server -y
sudo apt-get install amqp-tools -y
sudo npm install rabbit.js
