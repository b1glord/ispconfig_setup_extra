## Install Hhvm Linuxeye 
### Prebuilt Packages on Centos 7.x
```
cd /tmp
wget -nc https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/hhvm/install_hhvm_linuxeye.sh
chmod a+x ./install_hhvm_linuxeye.sh
./install_hhvm_linuxeye.sh
```
## Install Hhvm Facebook  (Alternative) (kurulum uzun suruyor)
```
cd /tmp
wget -nc https://raw.githubusercontent.com/b1glord/ispconfig_setup_extra/master/centos7/hhvm/install_hhvm_facebook.sh
chmod a+x ./install_hhvm_facebook.sh
./install_hhvm_facebook.sh
```

### Now, on to configuring additional PHP versions!

#### Go to the System tab from the top horizontal menu if you aren't already there (which you really should!)
#### Click on Additional PHP Versions from the left side menu
#### Click on Add new PHP version
#### Add control panel identification data in the Name tab
#### Server should already be selected - if this were a multiserver setup, you could select another server.
#### Client should be left blank, unless you want this PHP version to be only available for a specific client

#### PHP Name is what you'll see in the panel to refer to this PHP version. 

### Type in ``Hhvm``

### Switch to the FastCGI Settings tab (no need to click save, the panel auto saves when moving between tabs).Here type:
#### Path to the PHP FastCGI binary     : ``/etc/hhvm``
#### Path to the php.ini directory      : ``/etc/hhvm``

### Switch to the PHP-FPM Settings tab. Here type:
#### Path to the PHP-FPM init script    : ``/etc/hhvm``
#### Path to the php.ini directory      : ``/etc/hhvm``
#### Path to the PHP-FPM pool directory : ``/etc/hhvm``
#### Click Save - you are done with Hhvm!
