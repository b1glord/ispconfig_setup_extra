#https://nginx.org/en/linux_packages.html
# Add nginx Repo
  cat > /etc/yum.repos.d/nginx.repo <<EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/7/basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/7/basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

yum update
sudo yum-config-manager --enable nginx-mainline
yum -y install nginx
yum -y install nginx-all-modules nginx-mod-http-geoip nginx-mod-http-image-filter nginx-mod-http-perl nginx-mod-http-xslt-filter nginx-mod-mail nginx-mod-stream

# Configure Nginx Default Port 81
#sed -i "s/    listen       80;/    listen       81;/" /etc/nginx/conf.d/default.conf

sed -i "s/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini

systemctl enable nginx.service
systemctl start nginx.service
