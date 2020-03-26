#!/usr/bin/env bash
#---------------------------------------------------------------------
# php_remi.sh
#
# ISPConfig 3 centos7 multi php version installer
#
# Script: php_remi.sh
# Version: 1.0.0
# Author: BigLorD <furytr@yandex.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------
# Ref http://www.hexblot.com/blog/centos7-ispconfig3-and-multiple-php-versions

# First, the IUS repo by Rackspace -
wget https://centos7.iuscommunity.org/ius-release.rpm

# Then the safe repository by Remi -
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# And get them installed:
rpm -ivh ius-release.rpm remi-release-7.rpm

# PHP 5.6 (Remi-safe repos)
yum install -y php56-php-bcmath php56-php-cli php56-php-common php56-php-fpm php56-php-gd php56-php-intl php56-php-mbstring php56-php-mcrypt php56-php-mysqlnd php56-php-opcache php56-php-pdo php56-php-pear php56-php-pecl-uploadprogress php56-php-soap php56-php-xml php56-php-xmlrpc
#
# Configure PHP 5.6 (Remi-safe repos)
# /opt/remi/php56/root/etc/php-fpm.d/www.conf
sed -i 's/listen = 127.0.0.1:9000/listen = 127.0.0.1:9006/' /opt/remi/php56/root/etc/php-fpm.d/www.conf

systemctl start php56-php-fpm
systemctl enable php56-php-fpm
systemctl status php56-php-fpm

# PHP 7.2 (Remi-safe repos)
yum install -y php72-php-bcmath php72-php-cli php72-php-common php72-php-fpm php72-php-gd php72-php-intl php72-php-json php72-php-mbstring php72-php-mcrypt php72-php-mysqlnd php72-php-opcache php72-php-pdo php72-php-pear php72-php-pecl-uploadprogress php72-php-pecl-zip php72-php-soap php72-php-xml php72-php-xmlrpc

# Configure PHP 7.2 (Remi-safe repos)
# /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i 's/listen = 127.0.0.1:9000/listen = 127.0.0.1:9007/' /etc/opt/remi/php73/php-fpm.d/www.conf

systemctl start php72-php-fpm
systemctl enable php72-php-fpm
systemctl status php72-php-fpm

# PHP 7.3 (Remi-safe repos)
yum install -y php73-php-bcmath php73-php-cli php73-php-common php73-php-fpm php73-php-gd php73-php-intl php73-php-json php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pear php73-php-pecl-uploadprogress php73-php-pecl-zip php73-php-soap php73-php-xml php73-php-xmlrpc

# Configure PHP 7.3 (Remi-safe repos)
# /etc/opt/remi/php73/php-fpm.d/www.conf
sed -i 's/listen = 127.0.0.1:9000/listen = 127.0.0.1:9008/' /etc/opt/remi/php73/php-fpm.d/www.conf

systemctl start php73-php-fpm
systemctl enable php73-php-fpm
systemctl status php73-php-fpm

# Restart Ispconfig
/usr/local/ispconfig/server/server.sh
