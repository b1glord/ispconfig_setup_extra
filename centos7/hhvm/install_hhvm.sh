InstallHHVM() {
if [ $CFG_HHVM = "yes" ]; then
    echo -n "Installing HHVM (Hip Hop Virtual Machine)... "

rpm -Uvh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/hhvm/repo/hhvm-3.15.3-1.el7.centos.x86_64.rpm
rpm -Uvh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/hhvm/repo/hhvm-devel-3.15.3-1.el7.centos.x86_64.rpm

yum-config-manager --save --setopt=hhvm.skip_if_unavailable=true
yum install cpp gcc-c++ cmake3 git psmisc {binutils,boost,jemalloc,numactl}-devel \
{ImageMagick,sqlite,tbb,bzip2,openldap,readline,elfutils-libelf,gmp,lz4,pcre}-devel \
lib{xslt,event,yaml,vpx,png,zip,icu,mcrypt,memcached,cap,dwarf}-devel \
{unixODBC,expat,mariadb}-devel lib{edit,curl,xml2,xslt}-devel \
glog-devel oniguruma-devel ocaml gperf enca libjpeg-turbo-devel openssl-devel \
mariadb mariadb-server {fastlz,double-conversion,re2}-devel make -y
yum install {fribidi,libc-client,glib2}-devel -y

rpm -Uvh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/hhvm/repo/hhvm-3.15.3-1.el7.centos.x86_64.rpm
rpm -Uvh https://github.com/b1glord/ispconfig_setup_extra/raw/master/centos7/hhvm/repo/hhvm-devel-3.15.3-1.el7.centos.x86_64.rpm

  cat > /etc/systemd/system/hhvm.service << EOF
[Unit]
Description=HHVM HipHop Virtual Machine (FCGI)
After=network.target nginx.service mariadb.service
 
[Service]
ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --mode daemon -vServer.Type=fastcgi -vServer.FileSocket=/var/log/hhvm/hhvm.sock
Restart=always
# Restart service after 10 seconds if the hhvm service crashes:
RestartSec=10
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF
# Configure Hhvm 
sed -i "s/hhvm.server.port = 9001/;hhvm.server.port = 9001/" /etc/hhvm/server.ini
sed -i "/;hhvm.server.port = 9001/a hhvm.server.file_socket=/var/log/hhvm/hhvm.sock" /etc/hhvm/server.ini
sed -i "s%date.timezone = Asia/Calcutta%date.timezone = $TIME_ZONE%" /etc/hhvm/server.ini
mkdir /var/log/hhvm
# Start Hhvm Service
systemctl start hhvm
 echo -e "[${green}DONE${NC}]\n"
 fi
}
