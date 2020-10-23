#phpMyAdmin
#Ref Url : https://phoenixnap.com/kb/install-phpmyadmin-on-centos-8

#In a terminal window, enter the following command to download the phpMyAdmin file:
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.zip

#Extract the .zip file archive:
unzip phpMyAdmin-4.9.4-all-languages.zip

# Move the extracted files to the /usr/share/phpmyadmin directory:
sudo mv phpMyAdmin-4.9.4-all-languages.zip /usr/share/phpMyAdmin

#Change directories:
cd /usr/share/phpMyAdmin

#Rename the sample php configuration file:
sudo mv config.sample.inc.php config.inc.php

#Open the php configuration file for editing:
#sudo nano config.inc.php
#Find the following line:
#$cfg['blowfish_secret'] = '';
#Edit the line and enter the new php root password between the single-quotes, as follows:
#$cfg[‘blowfish_secret’]=’mysql root password’;

#Next, create and set permissions on a temporary phpMyAdmin directory:
mkdir /usr/share/phpmyadmin/tmp
chown -R apache:apache /usr/share/phpmyadmin
chmod 777 /usr/share/phpmyadmin/tmp


systemctl restart httpd
