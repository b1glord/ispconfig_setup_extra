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
#-vServer.FileSocket=/var/run/hhvm/hhvm.sock
#hhvm.server.file_socket=/var/run/hhvm/hhvm.sock
#
#---------------------------------------------------------------------

#https://www.howtoforge.com/tutorial/how-to-install-wordpress-with-hhvm-and-nginx-on-centos-7/#step-configure-hhvm-and-nginx
#http://mirrors.linuxeye.com/hhvm-repo/7/x86_64/

#Add Repository Hvvm PreBuild Installation
touch /etc/yum.repos.d/hhvm.repo
echo "[hhvm]" >> /etc/yum.repos.d/hhvm.repo
echo "name=gleez hhvm-repo" >> /etc/yum.repos.d/hhvm.repo
echo "baseurl=http://mirrors.linuxeye.com/hhvm-repo/7/\$basearch/" >> /etc/yum.repos.d/hhvm.repo
echo "enabled=1" >> /etc/yum.repos.d/hhvm.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/hhvm.repo

  echo -n "Installing HHVM HipHop Virtual Machine (FCGI)... "
   yum -y install hhvm

# Configure Hhvm (optional)
#wget https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/hhvm/config.hdf -P /etc/hhvm/
#wget https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/hhvm/static.mime-types.hdf -P /usr/share/hhvm/hdf/
 mkdir /var/run/hhvm
 mkdir /var/log/hhvm

 TIME_ZONE=$(echo "$TIME_ZONE" | sed -n 's/ (.*)$//p')
 sed -i "s%date.timezone = Asia/Calcutta%date.timezone = $TIME_ZONE%" /etc/hhvm/server.ini







# Open Log (optional) 
sed -i "s%;pid = /var/log/hhvm/pid%pid = /var/log/hhvm/pid%" /etc/hhvm/server.ini

# Add System Startup
 echo "[Unit]" >> /etc/systemd/system/hhvm.service
 echo "Description=HHVM HipHop Virtual Machine (FCGI)" >> /etc/systemd/system/hhvm.service
 echo "After=network.target nginx.service mariadb.service" >> /etc/systemd/system/hhvm.service
 echo "" >> /etc/systemd/system/hhvm.service
 echo "[Service]" >> /etc/systemd/system/hhvm.service

echo "ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi -vServer.Port=9001" >> /etc/systemd/system/hhvm.service

echo "" >> /etc/systemd/system/hhvm.service
 echo "[Install]" >> /etc/systemd/system/hhvm.service
 echo "WantedBy=multi-user.target" >> /etc/systemd/system/hhvm.service

# Configure Log files hhvm.service (optional)
sed -i "s%ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi -vServer.Port=9001%ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi -vServer.Port=9001 -vLog.Level=Debug -vLog.File=/var/log/hhvm/hhvm.log%" /etc/systemd/system/hhvm.service

systemctl daemon-reload
systemctl restart hhvm
systemctl status hhvm

 hhvm --version
 echo -e "[${green}DONE${NC}]\n"
