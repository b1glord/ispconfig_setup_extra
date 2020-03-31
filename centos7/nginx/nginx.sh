#https://nginx.org/en/linux_packages.html
# Add nginx Repo
wget -N https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/nginx/nginx.repo -P /etc/yum.repos.d

yum update
sudo yum-config-manager --enable nginx-mainline
yum -y install nginx

# 1.16 add modules
#yum -y install nginx-all-modules nginx-mod-http-geoip nginx-mod-http-image-filter nginx-mod-http-perl nginx-mod-http-xslt-filter nginx-mod-mail nginx-mod-stream

# 1.17 add modules
yum -y install nginx-module-geoip nginx-module-image-filter nginx-module-njs nginx-module-perl nginx-module-xslt

# Configure Nginx Default Port 81
#sed -i "s/    listen       80;/    listen       81;/" /etc/nginx/conf.d/default.conf
# Configure cgi.fix_pathinfo
sed -i "s/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini
# Configure startup and start
systemctl enable nginx.service
systemctl start nginx.service
