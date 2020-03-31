### IspConfig Additional PHP Versions kısmında Hhvm ile kullanmak icin ozel php-fpm modulu
#### port:9001 dinleyecek sekilde duzenledim

```
rpm -ivh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/hhvm/hhvm-fpm/php70-php-fpm-7.0.33-18.el7.remi.x86_64.rpm --nodeps
```
#### Configure 
```
sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:9001/" /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s/user = apache/user = nginx/" /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s/group = apache/group = nginx/" /etc/opt/remi/php70/php-fpm.d/www.conf
```
#### Start Service
```
systemctl start php70-php-fpm
systemctl restart php70-php-fpm
systemctl status php70-php-fpm
```

### IspConfig => Additional PHP Versions
#### Add Hhvm

#### Path to the PHP-FPM init script 	  :	
```/etc/opt/remi/php70/sysconfig/php-fpm```
#### Path to the php.ini directory   	  :	
```/etc/hhvm/php.ini```
#### Path to the PHP-FPM pool directory	:	
```/etc/opt/remi/php70/php-fpm.d/```


### asagidaki adreste Degisik bir tetikleme yontemi ile toplu restart
#### WantsTo yerine BindsTo kullanarak tek komutla digerlerini de tetiklemek sanirim mumkun
* https://faq-howto.com/centos-additional-php-versions-with-ispconfig3/

#### Asagidaki ornekteki gibi
```
vi /lib/systemd/system/php70-fpm.service

[Unit] Description=The PHP FastCGI Process Manager
After=syslog.target network.target
BindsTo=php-fpm.service 
```
