#!/usr/bin/env bash
#---------------------------------------------------------------------
# install_epel.sh
#
# ISPConfig 3 centos7 hhvm facebook installer
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
 
 echo -n "Enable the Centos 7 EPEL repository "
	rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	
# Veya
# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

