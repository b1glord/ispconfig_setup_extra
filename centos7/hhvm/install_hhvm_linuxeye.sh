#!/usr/bin/env bash
#---------------------------------------------------------------------
# install_hhvm_linuxeye.txt
#
# ISPConfig 3 centos7 hhvm installer
#
# Script: install_hhvm_linuxeye.sh
# Version: 1.0.0
# Author: BigLorD <furytr@yandex.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
# Additional /etc/systemd/system/hhvm.service command
#-vServer.Port=9010
#-vPidFile=/var/run/hhvm/pid
#-vPidFile=/var/run/spawn-fcgi.pid
#hhvm.server.file_socket=/var/run/fcgiwrap.socket
#hhvm.server.file_socket=/var/run/hhvm/hhvm.sock
#
# Additional /etc/systemd/system/hhvm.service command only nginx (need install fcgiwrap)
#ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi hhvm.server.file_socket=/var/run/fcgiwrap.socket
#
#---------------------------------------------------------------------

#https://www.howtoforge.com/tutorial/how-to-install-wordpress-with-hhvm-and-nginx-on-centos-7/#step-configure-hhvm-and-nginx
#http://mirrors.linuxeye.com/hhvm-repo/7/x86_64/

  yum -y install cpp gcc-c++ cmake git psmisc {binutils,boost,jemalloc,numactl}-devel \
{ImageMagick,sqlite,tbb,bzip2,openldap,readline,elfutils-libelf,gmp,lz4,pcre}-devel \
lib{xslt,event,yaml,vpx,png,zip,icu,mcrypt,memcached,cap,dwarf}-devel \
{unixODBC,expat,mariadb}-devel lib{edit,curl,xml2,xslt}-devel \
glog-devel oniguruma-devel ocaml gperf enca libjpeg-turbo-devel openssl-devel \
mariadb mariadb-server make libc-client 

  echo -n "Installing HHVM HipHop Virtual Machine (FCGI)... "
   yum -y install zeromq-devel
rpm -Uvh http://mirrors.linuxeye.com/hhvm-repo/7/x86_64/hhvm-3.15.3-1.el7.centos.x86_64.rpm

# Configure Hhvm (optional)
 mkdir /var/run/hhvm
 mkdir /var/log/hhvm
 TIME_ZONE=$(echo "$TIME_ZONE" | sed -n 's/ (.*)$//p')
 sed -i "s%date.timezone = Asia/Calcutta%date.timezone = $TIME_ZONE%" /etc/hhvm/server.ini
# Configure hhvm.service (optional)
sed -i "s%ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi -vServer.Port=9001%ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi -vServer.Port=9001 -vLog.Level=Debug -vLog.File=/var/log/hhvm/hhvm.log%" /etc/hhvm/server.ini

systemctl daemon-reload
systemctl restart hhvm.service

 hhvm --version
 echo -e "[${green}DONE${NC}]\n"
