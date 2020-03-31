releasever=
basearch=$(uname -m)

#https://nginx.org/en/linux_packages.html
# Add nginx Repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

yum update
sudo yum-config-manager --enable nginx-mainline
yum -y install nginx


if [ -f /etc/centos-release ]; then
    OS="CentOs"
    VERFULL=$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)
    VER=${VERFULL:0:1} # return 6 or 7
elif [ -f /etc/lsb-release ]; then
    OS=$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')
    VER=$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')
else
    OS=$(uname -s)
    VER=$(uname -r)
fi


# 1.16 modules
yum -y install nginx-all-modules nginx-mod-http-geoip nginx-mod-http-image-filter nginx-mod-http-perl nginx-mod-http-xslt-filter nginx-mod-mail nginx-mod-stream
# 1.17 modules
yum -y install nginx-module-geoip nginx-module-image-filter nginx-module-njs nginx-module-perl nginx-module-xslt
# Configure Nginx Default Port 81
#sed -i "s/    listen       80;/    listen       81;/" /etc/nginx/conf.d/default.conf

sed -i "s/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini

systemctl enable nginx.service
systemctl start nginx.service
