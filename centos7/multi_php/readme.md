## Install Redhat
```
cd /tmp
wget -nc https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/multi_php/php_redhat.sh
chmod a+x ./php_redhat.sh
./php_redhat.sh
```

## Install Remi
```
cd /tmp
wget -nc https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/multi_php/php_remi.sh
chmod a+x ./php_remi.sh
./php_remi.sh
```

### Restart Ispconfig
```
/usr/local/ispconfig/server/server.sh
```

