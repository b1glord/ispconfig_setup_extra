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

yum-config-manager --save --setopt=hhvm.skip_if_unavailable=true
yum -y install cpp gcc-c++ cmake git psmisc {binutils,boost,jemalloc,numactl}-devel \
{ImageMagick,sqlite,tbb,bzip2,openldap,readline,elfutils-libelf,gmp,lz4,pcre}-devel \
lib{xslt,event,yaml,vpx,png,zip,icu,mcrypt,memcached,cap,dwarf}-devel \
{unixODBC,expat,mariadb}-devel lib{edit,curl,xml2,xslt}-devel \
glog-devel oniguruma-devel ocaml gperf enca libjpeg-turbo-devel openssl-devel \
make libc-client

rpm -Uvh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/hhvm/repo/hhvm-3.15.3-1.el7.centos.x86_64.rpm
rpm -Uvh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/hhvm/repo/hhvm-devel-3.15.3-1.el7.centos.x86_64.rpm

  cat > /etc/systemd/system/hhvm.service << EOF
[Unit]
Description=HHVM HipHop Virtual Machine (FCGI)
After=network.target nginx.service mariadb.service
 
[Service]
ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --mode daemon -vServer.Type=fastcgi -vServer.FileSocket=/var/log/hhvm/hhvm.sock
Restart=always
# Restart service after 10 seconds if the hhvm service crashes:
RestartSec=10
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF
# Configure Hhvm 
sed -i "s/hhvm.server.port = 9001/;hhvm.server.port = 9001/" /etc/hhvm/server.ini
sed -i "/;hhvm.server.port = 9001/a hhvm.server.file_socket=/var/log/hhvm/hhvm.sock" /etc/hhvm/server.ini
sed -i "s%date.timezone = Asia/Calcutta%date.timezone = $TIME_ZONE%" /etc/hhvm/server.ini
mkdir /var/log/hhvm
# Start Hhvm Service
systemctl start hhvm

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
}
