#!/usr/bin/env bash
#---------------------------------------------------------------------
# certbot.sh
#
# ISPConfig 3 centos7 certbot installer
#
# Script: certbot.sh
# Version: 1.0.0
# Author: BigLorD <furytr@yandex.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------
# https://certbot.eff.org/lets-encrypt/centosrhel7-apache

yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum -y install yum-utils
yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional

sudo yum install certbot python2-certbot-apache

echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
