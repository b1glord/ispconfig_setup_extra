#https://nginx.org/en/linux_packages.html
# Add nginx Repo
wget -nc https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/nginx/nginx.repo -P /etc/yum.repos.d

yum update
yum install -y nginx
yum install -y nginx-all-modules nginx-mod-http-geoip nginx-mod-http-image-filter nginx-mod-http-perl nginx-mod-http-xslt-filter nginx-mod-mail nginx-mod-stream

# Configure Nginx Default Port 81
#sed -i "s/    listen       80;/    listen       81;/" /etc/nginx/conf.d/default.conf

sed -i "s/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini

systemctl enable nginx.service
systemctl start nginx.service
