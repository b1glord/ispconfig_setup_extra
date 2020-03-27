# Ref: https://www.digitalocean.com/community/tutorials/how-to-reset-your-mysql-or-mariadb-root-password
# MariaDB 10.1.20 and older reset password

sudo systemctl stop mariadb
sudo systemctl stop mysql
sudo mysqld_safe --skip-grant-tables --skip-networking &
mysql -u root
FLUSH PRIVILEGES;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('11521152');
exit
sudo kill /var/run/mariadb/mariadb.pid
sudo systemctl start mariadb
