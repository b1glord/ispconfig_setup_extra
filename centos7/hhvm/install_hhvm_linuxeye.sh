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
  cat > /etc/yum.repos.d/hhvm.repo << EOF
[hhvm]
name=gleez hhvm-repo
baseurl=http://mirrors.linuxeye.com/hhvm-repo/7/\$basearch/
enabled=1
gpgcheck=0
EOF

  echo -n "Installing HHVM HipHop Virtual Machine (FCGI)... "
  yum -y install hhvm

# Add System Startup
  systemctl enable hhvm
  chmod +x /etc/rc.local
  cat > /etc/rc.local << EOF
#!/bin/bash
# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
#
# It is highly advisable to create own systemd services or udev rules
# to run scripts during boot instead of using this file.
#
# In contrast to previous versions due to parallel execution during boot
# this script will NOT be run after all other services.
#
# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
# that this script will be executed during boot.

touch /var/lock/subsys/local
mkdir -p /var/run/hhvm/
chown -R nginx:nginx /var/run/hhvm/
semanage fcontext -a -t httpd_var_run_t "/var/run/hhvm(/.*)?"
restorecon -Rv /var/run/hhvm
EOF

# Configure Hhvm 
sed -i "s%;pid = /var/log/hhvm/pid%pid = /var/run/hhvm/hhvm.pid%" /etc/hhvm/server.ini
sed -i "s%hhvm.pid_file = "/var/log/hhvm/pid"%hhvm.pid_file = "/var/log/hhvm/hhvm.pid"%" /etc/hhvm/server.ini
sed -i "s/hhvm.server.port = 9001/;hhvm.server.port = 9001/" /etc/hhvm/server.ini
sed -i "/;hhvm.server.port = 9001/a hhvm.server.file_socket=/var/run/hhvm/hhvm.sock" /etc/hhvm/server.ini
sed -i "s%hhvm.repo.central.path = /var/run/hhvm/hhvm.hhbc%hhvm.repo.central.path = /var/cache/hhvm/hhvm.hhbc%" /etc/hhvm/server.ini
sed -i "s%date.timezone = Asia/Calcutta%date.timezone = $TIME_ZONE%" /etc/hhvm/server.ini
sed -i "s%ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi -vServer.Port=9001%ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --config /etc/hhvm/php.ini --user nginx --mode daemon -vServer.Type=fastcgi -vServer.FileSocket=/var/run/hhvm/hhvm.sock -vLog.Level=Debug -vLog.File=/var/log/hhvm/hhvm.log%" /usr/lib/systemd/system/hhvm.service

if [ "$CFG_WEBSERVER" == "apache" ]; then
	CFG_NGINX=n
	CFG_APACHE=y
mkdir /var/log/hhvm /var/cache/hhvm /var/run/hhvm
sudo chown apache:apache /var/log/hhvm /var/cache/hhvm /var/run/hhvm
chmod 0770 /var/log/hhvm /var/cache/hhvm /var/run/hhvm
sed -i "s%chown -R nginx:nginx /var/run/hhvm/%chown -R apache:apache /var/run/hhvm/%" /etc/rc.local
wget -nc https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/hhvm/files/apache2/mods-available/hhvm_proxy_fcgi.conf -P /etc/httpd/conf.d/
sed -i "s/--user nginx/--user apache/" /usr/lib/systemd/system/hhvm.service
elif [ "$CFG_WEBSERVER" == "nginx" ]; then
  	CFG_NGINX=y
	CFG_APACHE=n
usermod -a -G apache nginx
mkdir /var/log/hhvm /var/cache/hhvm /var/run/hhvm
sudo chown nginx:nginx /var/log/hhvm /var/cache/hhvm /var/run/hhvm
chmod 0770 /var/log/hhvm /var/cache/hhvm /var/run/hhvm
sed -i "s/--user nginx/--user nginx/" /usr/lib/systemd/system/hhvm.service
fi
systemctl daemon-reload
wget -nc https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/hhvm/test/hhvminfo.php -P /var/www
wget -nc https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/hhvm/test/phpinfo.php -P /var/www

systemctl start hhvm
systemctl status hhvm
hhvm --version
 echo -e "[${green}DONE${NC}]\n"
 fi
}
