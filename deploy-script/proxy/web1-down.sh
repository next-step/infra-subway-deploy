#!/bin/bash

sudo echo -e "server 192.168.100.109:8080 down;\nserver 192.168.100.157:8080;" > /etc/nginx/upstream.conf
sudo nginx -s reload