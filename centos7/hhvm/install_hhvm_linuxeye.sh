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
#
#---------------------------------------------------------------------
#https://www.howtoforge.com/tutorial/how-to-install-wordpress-with-hhvm-and-nginx-on-centos-7/#step-configure-hhvm-and-nginx
#http://mirrors.linuxeye.com/hhvm-repo/7/x86_64/

 echo -n "Installing Hhvm (nginx)... "
 yum install -y git zeromq-devel
 
 yum install -y cpp gcc-c++ cmake psmisc {binutils,boost,jemalloc,numactl}-devel \
 {ImageMagick,sqlite,tbb,bzip2,openldap,readline,elfutils-libelf,gmp,lz4,pcre}-devel \
 lib{xslt,event,yaml,vpx,png,zip,icu,mcrypt,memcached,cap,dwarf}-devel \
 {unixODBC,expat,mariadb}-devel lib{edit,curl,xml2,xslt}-devel \
 glog-devel oniguruma-devel ocaml gperf enca libjpeg-turbo-devel openssl-devel \
 mariadb mariadb-server libc-client make

 rpm -Uvh http://mirrors.linuxeye.com/hhvm-repo/7/x86_64/hhvm-3.15.3-1.el7.centos.x86_64.rpm

# Configure Hhvm (optional)
 ln -s /usr/local/bin/hhvm /bin/hhvm
 mkdir /var/run/hhvm/
# Change the port (optional)
#sed -i "s/hhvm.server.port = 9001/hhvm.server.port = 9009/" /etc/hhvm/server.ini
sed -i "s%date.timezone = Asia/Calcutta%date.timezone = Europe/Istanbul%" /etc/hhvm/server.ini


 echo "[Unit]" >> /etc/systemd/system/hhvm.service
 echo "Description=HHVM HipHop Virtual Machine (FCGI)" >> /etc/systemd/system/hhvm.service
 echo "After=network.target nginx.service mariadb.service" >> /etc/systemd/system/hhvm.service
 echo "" >> /etc/systemd/system/hhvm.service
 echo "[Service]" >> /etc/systemd/system/hhvm.service
 echo "ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user apache2 --mode daemon -vServer.Type=fastcgi -  vServer.FileSocket=/var/run/hhvm/hhvm.sock" >> /etc/systemd/system/hhvm.service
#echo "ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi -  vServer.FileSocket=/var/run/hhvm/hhvm.sock" >> /etc/systemd/system/hhvm.service
 echo "" >> /etc/systemd/system/hhvm.service
 echo "[Install]" >> /etc/systemd/system/hhvm.service
 echo "WantedBy=multi-user.target" >> /etc/systemd/system/hhvm.service

 hhvm --version
 echo -e "[${green}DONE${NC}]\n"
