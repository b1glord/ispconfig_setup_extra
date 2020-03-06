#!/usr/bin/env bash
#---------------------------------------------------------------------
# install_epel.sh
#
# ISPConfig 3 Centos 8 EPEL repository installer
#
# Script: install_epel.sh
# Version: 1.0.0
# Author: BigLorD <furytr@yandex.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------
#Ref: https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F
 
 echo -n "Enable the Centos 8 EPEL repository "
	dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

