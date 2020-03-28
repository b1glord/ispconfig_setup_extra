InstallHHVM() {
  if [ $CFG_HHVM = "yes" ]; then
#Add Repository Hvvm PreBuild Installation
touch /etc/yum.repos.d/hhvm.repo
echo "[hhvm]" >> /etc/yum.repos.d/hhvm.repo
echo "name=gleez hhvm-repo" >> /etc/yum.repos.d/hhvm.repo
echo "baseurl=http://mirrors.linuxeye.com/hhvm-repo/7/\$basearch/" >> /etc/yum.repos.d/hhvm.repo
echo "enabled=1" >> /etc/yum.repos.d/hhvm.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/hhvm.repo

  echo -n "Installing HHVM HipHop Virtual Machine (FCGI)... "
   yum -y install hhvm

# Configure Hhvm (optional)
 mkdir /var/run/hhvm
 mkdir /var/log/hhvm
TIME_ZONE=$(echo "$TIME_ZONE" | sed -n 's/ (.*)$//p')
sed -i "s%date.timezone = Asia/Calcutta%date.timezone = $TIME_ZONE%" /etc/hhvm/server.ini

# Add System Startup
 echo "[Unit]" >> /etc/systemd/system/hhvm.service
 echo "Description=HHVM HipHop Virtual Machine (FCGI)" >> /etc/systemd/system/hhvm.service
 echo "After=network.target nginx.service mariadb.service" >> /etc/systemd/system/hhvm.service
 echo "" >> /etc/systemd/system/hhvm.service
 echo "[Service]" >> /etc/systemd/system/hhvm.service

echo "ExecStart=/usr/local/bin/hhvm --config /etc/hhvm/server.ini --user nginx --mode daemon -vServer.Type=fastcgi -vServer.Port=9001" >> /etc/systemd/system/hhvm.service

echo "" >> /etc/systemd/system/hhvm.service
 echo "[Install]" >> /etc/systemd/system/hhvm.service
 echo "WantedBy=multi-user.target" >> /etc/systemd/system/hhvm.service

systemctl daemon-reload
systemctl restart hhvm
systemctl status hhvm

 hhvm --version
 echo -e "[${green}DONE${NC}]\n"
 fi
}
