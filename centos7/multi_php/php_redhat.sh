#!/usr/bin/env bash
#---------------------------------------------------------------------
# php_redhat.sh
#
# ISPConfig 3 centos7 multi php version installer
#
# Script: php_redhat.sh
# Version: 1.0.0
# Author: BigLorD <furytr@yandex.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------
# Ref: https://www.softwarecollections.org/en/scls/rhscl/rh-php72/


# 1. Install a package with repository centos-release-scl available in CentOS repository:
yum install centos-release-scl

# 2.On RHEL, enable RHSCL repository for you system
yum-config-manager --enable rhel-server-rhscl-7-rpms

# 3. Install the php:
sudo yum install rh-php72

# 3. Install the php collection:
sudo yum list rh-php72\*
sudo yum install rh-php72-php-bcmath rh-php72-php-dba rh-php72-php-dbg rh-php72-php-devel rh-php72-php-embedded rh-php72-php-enchant rh-php72-php-fpm rh-php72-php-gd rh-php72-php-gmp rh-php72-php-intl rh-php72-php-ldap rh-php72-php-mbstring rh-php72-php-mysqlnd rh-php72-php-odbc rh-php72-php-opcache rh-php72-php-pdo rh-php72-php-pecl-apcu rh-php72-php-pecl-apcu-devel rh-php72-php-pgsql rh-php72-php-pspell rh-php72-php-recode rh-php72-php-snmp rh-php72-php-soap rh-php72-php-xmlrpc rh-php72-scldevel 

# 4. Start using the software collection:
$ scl enable rh-php72 bash

# 5. Start using the Php-Fpm:
service rh-php72-php-fpm start
