#https://www.techbrown.com/configure-lets-encrypt-ssl-apache-centos-7/
#https://www.hostinger.com/tutorials/vps/how-to-install-lets-encrypt-ssl-apache-centos7

cd /opt
git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt/
./letsencrypt-auto --apache -d test.com --verbose
