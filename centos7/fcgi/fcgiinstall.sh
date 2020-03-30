 echo -n "Installing fcgiwrap... "
#	yum -y install epel-release fcgiwrap spawn-fcgi fcgi-devel
rpm -ivh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/fcgi/fcgi-devel-2.4.0-25.el7.x86_64.rpm
rpm -ivh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/fcgi/fcgiwrap-1.1.0-12.20181108git99c942c.el7.x86_64.rpm
rpm -ivh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/fcgi/spawn-fcgi-1.6.3-5.el7.x86_64.rpm

# modify the /etc/sysconfig/spawn-fcgi file as follows:
echo '# You must set some working options before the "spawn-fcgi" service will work.' >> /etc/sysconfig/spawn-fcgi
echo "# If SOCKET points to a file, then this file is cleaned up by the init script." >> /etc/sysconfig/spawn-fcgi
echo "#" >> /etc/sysconfig/spawn-fcgi
echo "# See spawn-fcgi(1) for all possible options." >> /etc/sysconfig/spawn-fcgi
echo "#" >> /etc/sysconfig/spawn-fcgi
echo "# Example :" >> /etc/sysconfig/spawn-fcgi
echo "#SOCKET=/var/run/php-fcgi.sock" >> /etc/sysconfig/spawn-fcgi
echo '#OPTIONS="-u nginx -g nginx -s $SOCKET -S -M 0600 -C 32 -F 1 -P /var/run/spawn-fcgi.pid -- /usr/bin/php-cgi"' >> /etc/sysconfig/spawn-fcgi
echo "FCGI_SOCKET=/var/run/fcgiwrap.socket" >> /etc/sysconfig/spawn-fcgi
echo "FCGI_PROGRAM=/usr/sbin/fcgiwrap" >> /etc/sysconfig/spawn-fcgi
echo "FCGI_USER=apache" >> /etc/sysconfig/spawn-fcgi
echo "FCGI_GROUP=apache" >> /etc/sysconfig/spawn-fcgi
echo 'FCGI_EXTRA_OPTIONS="-M 0770"' >> /etc/sysconfig/spawn-fcgi
echo 'OPTIONS="-u $FCGI_USER -g $FCGI_GROUP -s $FCGI_SOCKET -S $FCGI_EXTRA_OPTIONS -F 1 -P /var/run/spawn-fcgi.pid -- $FCGI_PROGRAM"' >> /etc/sysconfig/spawn-fcgi

#Now add the user nginx to the group apache:
	usermod -a -G apache nginx
	chkconfig spawn-fcgi on
	systemctl start spawn-fcgi
  systemctl status spawn-fcgi
