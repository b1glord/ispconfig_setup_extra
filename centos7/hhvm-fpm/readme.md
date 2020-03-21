### IspConfig Additional PHP Versions kısmında Hhvm ile kullanmak icin ozel php-fpm modulu
#### port:9001 dinleyecek sekilde duzenlenecek

```
rpm -ivh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/hhvm-fpm/php70-php-fpm-7.0.33-18.el7.remi.x86_64.rpm --nodeps
```
#### Configure 
```
sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:9001/" /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s/user = apache/user = nginx/" /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s/group = apache/group = nginx/" /etc/opt/remi/php70/php-fpm.d/www.conf
```
#### Start Service
```
systemctl start php70-php-fpm.service
```



### IspConfig => Additional PHP Versions
#### Add Hhvm
```
Path to the PHP-FPM init script 	  :	/etc/opt/remi/php70/sysconfig/php-fpm
Path to the php.ini directory   	  :	/etc/hhvm/php.ini
Path to the PHP-FPM pool directory	:	/etc/opt/remi/php70/php-fpm.d/
```
