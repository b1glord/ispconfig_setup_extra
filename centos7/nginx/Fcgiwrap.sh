yum -y install fcgi-devel

cd /usr/local/src/
git clone git://github.com/gnosek/fcgiwrap.git
cd fcgiwrap
autoreconf -i
./configure
make
make install



yum -y install spawn-fcgi

#Open /etc/sysconfig/spawn-fcgi...
echo '
FCGI_SOCKET=/var/run/fcgiwrap.socket
FCGI_PROGRAM=/usr/local/sbin/fcgiwrap
FCGI_USER=apache
FCGI_GROUP=apache
FCGI_EXTRA_OPTIONS="-M 0770"
OPTIONS="-u $FCGI_USER -g $FCGI_GROUP -s $FCGI_SOCKET -S $FCGI_EXTRA_OPTIONS -F 1 -P /var/run/spawn-fcgi.pid -- $FCGI_PROGRAM"' >> /etc/sysconfig/spawn-fcgi


#Now add the user nginx to the group apache:

usermod -a -G apache nginx

#Create the system startup links for spawn-fcgi...

chkconfig spawn-fcgi on

#... and start it as follows:

systemctl start spawn-fcgi
