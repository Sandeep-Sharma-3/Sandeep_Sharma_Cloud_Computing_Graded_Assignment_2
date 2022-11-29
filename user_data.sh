#!/bin/bash
sudo -i
apt update -y
apt upgrade -y
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx