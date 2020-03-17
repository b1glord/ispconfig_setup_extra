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
# Additional /etc/systemd/system/hhvm.service command
#-vServer.Port=9010
#-d hhvm.admin_server.port=9011
#-vPidFile=/var/run/hhvm/pid
#-vServer.FileSocket=/var/run/fcgiwrap.socket
#-vServer.FileSocket=/var/run/hhvm/hhvm.sock

#---------------------------------------------------------------------
#https://www.howtoforge.com/tutorial/how-to-install-wordpress-with-hhvm-and-nginx-on-centos-7/#step-configure-hhvm-and-nginx
#http://mirrors.linuxeye.com/hhvm-repo/7/x86_64/

 echo -n "Installing HHVM HipHop Virtual Machine (FCGI)... "

touch /etc/yum.repos.d/hhvm.repo
echo "[hhvm]" >> /etc/yum.repos.d/hhvm.repo
echo "name=gleez hhvm-repo" >> /etc/yum.repos.d/hhvm.repo
echo "baseurl=http://mirrors.linuxeye.com/hhvm-repo/7/\$basearch/" >> /etc/yum.repos.d/hhvm.repo
echo "enabled=1" >> /etc/yum.repos.d/hhvm.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/hhvm.repo

 yum -y install zeromq-devel hhvm

# Configure Hhvm (optional)
 ln -s /usr/local/bin/hhvm /bin/hhvm
 mkdir /var/run/hhvm/
# Change the admin port
sed -i "s/hhvm.server.port = 9001/hhvm.server.port = 9011/" /etc/hhvm/server.ini
sed -i "s%date.timezone = Asia/Calcutta%date.timezone = $TIME_ZONE%" /etc/hhvm/server.ini

 echo "[Unit]" >> /etc/systemd/system/hhvm.service
 echo "Description=HHVM HipHop Virtual Machine (FCGI)" >> /etc/systemd/system/hhvm.service
 echo "After=network.target nginx.service mariadb.service" >> /etc/systemd/system/hhvm.service
 echo "" >> /etc/systemd/system/hhvm.service
 echo "[Service]" >> /etc/systemd/system/hhvm.service

#echo "ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user apache --mode daemon -vServer.Type=fastcgi -vServer.FileSocket=/var/run/hhvm/hhvm.sock" >> /etc/systemd/system/hhvm.service
echo "ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user apache --mode daemon -vServer.Type=fastcgi -vServer.Port=9010" >> /etc/systemd/system/hhvm.service

echo "" >> /etc/systemd/system/hhvm.service
 echo "[Install]" >> /etc/systemd/system/hhvm.service
 echo "WantedBy=multi-user.target" >> /etc/systemd/system/hhvm.service

systemctl enable hhvm.service
systemctl start hhvm.service
systemctl daemon-reload

 hhvm --version
 echo -e "[${green}DONE${NC}]\n"
