InstallVarnish() {
if [ $CFG_VARNISH = "yes" ]; then
  echo -n "Configure Webserver... "
  
  if [ "$CFG_WEBSERVER" == "apache" ]; then
	CFG_NGINX=n
	CFG_APACHE=y

# Setting Up Apache Service
  systemctl stop httpd.service
  sed -i "s/Listen 80/Listen 8060/" /etc/httpd/conf/httpd.conf
  systemctl start httpd.service

  elif [ "$CFG_WEBSERVER" == "nginx" ]; then
  	CFG_NGINX=y
	CFG_APACHE=n

# Setting Up Nginx Service Ver:1.20.1
  systemctl stop nginx.service
   sed -i "s/        listen       80;/        listen       8060;/" /etc/nginx/nginx.conf
   sed -i "s/        listen       [::]:80;/        listen       [::]:8060;/" /etc/nginx/nginx.conf
  systemctl start nginx.service
  fi
  
  echo -n "Installing Varnish Cache... "
    yum -y install varnish
  
  echo -n "Configure Varnish Cache... "
	  sed -i "s/VARNISH_LISTEN_PORT=6081/VARNISH_LISTEN_PORT=80/" /etc/varnish/varnish.params
	  sed -i 's/    .port = "8080";/    .port = "8060";/' /etc/varnish/default.vcl
    systemctl enable varnish.service  
    systemctl start varnish.service
      echo -e "${green}done! ${NC}\n"
fi
}
