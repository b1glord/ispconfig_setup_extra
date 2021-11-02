echo -n "Installing Ioncube Loader (PHP 7)... "
  cd /tmp
  wget -nc http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
  tar -xzvf ioncube_loaders_lin_x86-64.tar.gz

# ioncube klasorunu /tmp den usr/local klasorune tasiyoruz 
  mkdir /usr/local/ioncube
  mv -f /tmp/ioncube -t  /usr/local
 
#Php.ini dosyamıza asagidaki kodlari ekliyoruz
  sed -i '/;zend.script_encoding =/a ;;ioncube;;' /etc/php.ini
  sed -i '/;;ioncube;;/a zend_extension_ts=/usr/local/ioncube/ioncube_loader_lin_7.3_ts.so' /etc/php.ini
  sed -i '/;;ioncube;;/a zend_extension=/usr/local/ioncube/ioncube_loader_lin_7.3.so' /etc/php.ini
  service php-fpm restart
echo -e "[${green}DONE${NC}]\n"
