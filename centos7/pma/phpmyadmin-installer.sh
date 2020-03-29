#!/usr/bin/env bash
#Centos için PHPMyAdmin kurulum betiği
#
#Php 5 ve Php 7 de ortak calısacak bir surum yuklemek
#
#Bu yukleme deneysel bir senaryodur.  
#
#Güvenli bir kurulumla sonuçlanmayabilir.
#
#Kullanmak Kendi Sorumluluğunuzdadır
#
#Komut dosyası aşağıdaki dağıtımlarda test edilmiştir:
# - Centos 7
# - Centos 8
#
#
# Bu komut dosyası ...
#  - mevcut PHPMyAdmin kurulumunuzu ve yapılandırmanızı kaldırın
#  - Mevcut Olan Apache2, PHP ve mysql/mariadb icin gerekli ek paket kurulumu yapar
#  - MariaDB/Mysql sunucusunu kurulumu Yapar
#  - PHPMyAdmin'i resmi kaynaktan yükler ve yapılandırır
#  - yeni kurulan MariaDB'nin kök şifresini değiştirir
#  - 'phpmyadmin' @ 'localhost' veritabanı kullanıcısını siler ve yeniden oluşturur
#
#Katkilar icin: https://github.com/b1glord/ispconfig_setup_extra/blob/master/centos7/pma/phpmyadmin-installer.sh
#
#####
# Asagidaki secenekleri yapılandırın:
#####
#
# URL yayınlanan zip dosyasını almak için (29.04.2019)
PMA_URL=https://files.phpmyadmin.net/phpMyAdmin/4.8.5/phpMyAdmin-4.8.5-all-languages.zip
#
# Zip'in içerdiği bir dizin (".zip" olmadan dosya adı olmalıdır)
PMA_DIR=phpMyAdmin-4.8.5-all-languages
#
# 'Phpmyadmin' kullanıcısı için şifre belirle
# Bunu icin gerçekten güçlü bir sifre ayarlamanız gerekir ...
PHPMYNEWPW=PHPMyPass
#
# MySQL / MariaDB kök parolası.
# Yeni kurulumlarda varsayılan değer boş
DBROOTPW=
#
# Yeni MariaDB / MySQL veritabanı kök kullanıcı şifresi.
# Boş veya ayarlı değilse ya da sunucu önceden kurulmuşsa atlandı.
# Bunun icin gerçekten güçlü bir sifre ayarlamanız gerekir ...
DBROOTNEWPW=SQLRootPass
#
# Çağrınız MariaDB (MySQL) sunucusunu kurun.
# Boş veya ayarlı değilse ya da sunucu önceden kurulmuşsa atlandı.
#DBSERVER=mysql-server
DBSERVER=mariadb-server
#
#####
# Ne yaptığını gerçekten bilmiyorsan bunlara dokunma!
#####
#
RANDOMSTRING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
WORKDIR=/tmp/phpmyadmin-$RANDOMSTRING
INSTALLDIR=/usr/share/phpmyadmin
CACHEDIR=/var/lib/phpmyadmin
CONFIGDIR=/etc/phpmyadmin
#
#####
# İşe başlayalım!
#####
#
if [ $(id -u) -ne 0 ]; then echo "Bu komut dosyasını kök ayrıcalıklarıyla çalıstır."; exit 1; fi
cat /etc/centos-release >/dev/null
if [ $? -ne 0 ]; then echo "centos-release bulunamadı, devam edilemez."; exit 1; fi
which yum >/dev/null
if [ $? -ne 0 ]; then echo "yum bulunamadı, devam edilemez."; exit 1; fi
yum -y install wget
which wget >/dev/null
if [ $? -ne 0 ]; then echo "wget bulunamadı, devam edilemez."; exit 1; fi
which egrep >/dev/null
if [ $? -ne 0 ]; then echo "egrep bulunamadı, devam edilemez."; exit 1; fi
#
############### YUM BLOCK ###############
echo "Distribution: $(centos-release -sd) ($(centos-release -sc))"
case $(centos-release -sc) in
    buster)
        PACKAGES="unzip apache2 libapache2-mod-php php php-mysqli php-pear php-zip \
            php-bz2 php-mbstring php-xml php-php-gettext php-phpseclib php-curl php-gd"
        ;;
    stretch|buster|bionic|disco)
        PACKAGES="unzip apache2 libapache2-mod-php php php-mysqli php-pear php-zip \
            php-bz2 php-tcpdf php-mbstring php-xml php-php-gettext php-phpseclib php-curl php-gd"
        ;;
    *)
        echo "Your distribution is not yet supported - perhaps it's just not listed yet."
        echo "Contributions welcome: https://github.com/direc85/phpmyadmin-installer"
        exit 1
        ;;
esac

if [ $(yum history 2>/dev/null | grep phpmyadmin | wc -l) -eq 1 ]; then
    echo "Purging phpmyadmin package..."
    yum remove -y --purge phpmyadmin >/dev/null
fi

if [ $(apt list --installed 2>/dev/null | egrep "mariadb-server|mysql-server" | wc -l) -ge 1 ]; then
    echo "MariaDB/MySQL server detected."
    DBSERVER=
    DBROOTNEWPW=
fi

echo "Installing packages (this may take some time)..."
DEBIAN_FRONTEND=noninteractive apt-get install -y $PACKAGES $DBSERVER >/dev/null
if [ $? -ne 0 ]; then
    echo "Error installing packages using apt-get"
    echo "Command: apt-get install -y $PACKAGES"
    exit 1
fi

############### PHPMYADMIN BLOCK ###############

rm -rf $WORKDIR
mkdir $WORKDIR
cd $WORKDIR

echo "Downloading PHPMyAdmin..."
wget --quiet $PMA_URL -O phpmyadmin.zip
if [ $? -ne 0 ]; then
    echo "Error downloading PHPMyAdmin zip archive."
    echo "URL: $PMA_URL"
    exit 1
fi 

echo "Decompressing PHPMyAdmin..."
unzip -q phpmyadmin.zip
if [ $? -ne 0 ]; then
    echo "Error extracting PHPMyAdmin zip archive."
    exit 1
fi

if [ ! -d "$PMA_DIR" ]; then
    echo "Error locating PHPMyAdmin source directory."
    echo "Please check $WORKDIR"
    echo "and update PMA_DIR variable in the script."
    exit 1
fi

if [[ -f "$CONFIGDIR/config.inc.php" && ! -L "$CONFIGDIR/config.inc.php" ]]; then
    echo "Existing configure found in $CONFIGDIR/config.inc.php"
elif [[ -f "$INSTALLDIR/config.inc.php" && ! -L "$INSTALLDIR/config.inc.php" ]]; then
    echo "Existing configure found in $INSTALLDIR/config.inc.php"
    echo "Moving it to $CONFIGDIR/config.inc.php.$RANDOMSTRING"
    cp "$INSTALLDIR/config.inc.php" "$CONFIGDIR/config.inc.php.$RANDOMSTRING"
else
    echo "Creating $CONFIGDIR/config.inc.php..."
    echo "
    <?php
        \$cfg['blowfish_secret'] = '$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)';
        \$cfg['TempDir'] = '$CACHEDIR/tmp';
    ?>" > config.inc.php

    chown root:root config.inc.php
    chmod 640 config.inc.php
    mkdir -p "$CONFIGDIR"
    mv "config.inc.php" "$CONFIGDIR/config.inc.php"
    ln -s "$CONFIGDIR/config.inc.php" "$PMA_DIR/config.inc.php"
fi

if [ $(grep "blowfish_secret" "$CONFIGDIR/config.inc.php" | grep -v "\/\/" | wc -l) -lt 1 ]; then
    echo "Warning: $CONFIGDIR/config.inc.php doesn't seem to contain"
    echo "         \$cfg['blowfish_secret'] option."
    echo "         You may have to configure this yourself."
fi

echo "Installing PHPMyAdmin to $INSTALLDIR..."
rm -rf $INSTALLDIR
chown root:root $PMA_DIR -R
mv $PMA_DIR $INSTALLDIR
if [ $? -ne 0 ]; then
    echo "Error moving $PMA_DIR to $INSTALLDIR"
    exit 1
fi 

if [ -d $CACHEDIR ]; then
    echo "Removing old PHPMyAdmin cache..."
    rm -rf $CACHEDIR
fi

echo "Creating cache directories in $CACHEDIR..."
mkdir -p $CACHEDIR/tmp $CACHEDIR/cache
chown www-data:www-data $CACHEDIR -R
chmod 770 $CACHEDIR

############### DATABASE BLOCK ###############

echo "USE mysql;" > test.sql
if [ ! -z "$DBROOTPW" ]; then
    DBROOTPW=-p$DBROOTPW
fi
mysql -uroot $DBROOTPW < test.sql
if [ $? -ne 0 ]; then
    echo "Invalid database root password provided."
    exit 1
fi

if [ ! -z "$DBROOTNEWPW" ]; then
    echo "Changing database 'root'@'localhost' password..."
    echo "USE mysql;
        UPDATE user
            SET password=PASSWORD('$DBROOTNEWPW')
            WHERE User='root'
            AND Host = 'localhost';" > root_pw.sql
    mysql -uroot $DBROOTPW < root_pw.sql
    if [ $? -ne 0 ]; then
        echo "Error changing password."
        exit 1
    fi
    DBROOTPW=-p$DBROOTNEWPW
fi

echo "Create database user 'phpmyadmin'..."
echo "
    USE mysql;
    DROP PROCEDURE IF EXISTS mysql.pma_user_create;
    DELIMITER \$\$
    CREATE PROCEDURE mysql.pma_user_create()
    BEGIN
        DECLARE usercount BIGINT DEFAULT 0 ;
        SELECT COUNT(*)
        INTO usercount
        FROM mysql.user
            WHERE User = 'phpmyadmin' and  Host = 'localhost';
        IF usercount > 0 THEN
            DROP USER 'phpmyadmin'@'localhost';
        END IF;
        CREATE USER 'phpmyadmin'@'localhost'
            IDENTIFIED BY '$PHPMYNEWPW';
        GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost';
        FLUSH PRIVILEGES;
    END \$\$
    DELIMITER ;
    CALL mysql.pma_user_create() ;
    DROP PROCEDURE IF EXISTS mysql.pma_user_create;
    " > create_phpmyadmin_user.sql
mysql -uroot $DBROOTPW < create_phpmyadmin_user.sql
if [ $? -ne 0 ]; then
    echo "Creating database user failed."
    exit 1
fi
rm create_phpmyadmin_user.sql

mysql -uphpmyadmin -p$PHPMYNEWPW < $INSTALLDIR/sql/create_tables.sql
if [ $? -ne 0 ]; then
    echo "Creating PHPMyAdmin database failed."
    exit 1
fi

############### APACHE BLOCK ###############

if [ $(grep -lr "$INSTALLDIR" /etc/apache2/sites-available | wc -l) -gt 0 ]; then
    echo "PHPMyAdmin site already enabled."
else
    echo "Enabling PHPMyAdmin site in Apache2..."
    echo "Alias /phpmyadmin /usr/share/phpmyadmin
    <Directory /usr/share/phpmyadmin>
        DirectoryIndex index.php
        Options SymLinksIfOwnerMatch
    </Directory>
    <Directory /usr/share/phpmyadmin/templates>
        Require all denied
    </Directory>
    <Directory /usr/share/phpmyadmin/libraries>
        Require all denied
    </Directory>
    <Directory /usr/share/phpmyadmin/setup/lib>
        Require all denied
    </Directory>" > phpmyadmin.conf

    mv phpmyadmin.conf /etc/apache2/sites-available/
    a2ensite phpmyadmin >/dev/null
    echo "Reloading Apache2..."
    service apache2 reload >/dev/null
fi

if [ ! -z "$DBROOTNEWPW" ]; then
    echo "Database root password set to \"$DBROOTNEWPW\""
elif [ -z "$DBROOTPW" ]; then
    echo "Database root password is empty. Please change it."
else
    echo "Database root password not changed."
fi
echo "PHPMyAdmin credentials set to \"phpmyadmin\" / \"$PHPMYNEWPW\""
