### Now, on to configuring additional PHP versions!

#### Go to the System tab from the top horizontal menu if you aren't already there (which you really should!)
#### Click on Additional PHP Versions from the left side menu
#### Click on Add new PHP version
#### Add control panel identification data in the Name tab
#### Server should already be selected - if this were a multiserver setup, you could select another server.
#### Client should be left blank, unless you want this PHP version to be only available for a specific client

#### PHP Name is what you'll see in the panel to refer to this PHP version. Type in PHP5.6

### Switch to the FastCGI Settings tab (no need to click save, the panel auto saves when moving between tabs).Here type:
#### Path to the PHP FastCGI binary     : ``/opt/remi/php56/root/usr/bin/php-cgi``
#### Path to the php.ini directory      : ``/opt/remi/php56/root/etc``

### Switch to the PHP-FPM Settings tab. Here type:
#### Path to the PHP-FPM init script    : ``/opt/remi/php56/root/usr/sbin/php-fpm``
#### Path to the php.ini directory      : ``/opt/remi/php56/root/etc``
#### Path to the PHP-FPM pool directory : ``/opt/remi/php56/root/etc/php-fpm.d``
#### Click Save - you are done with PHP5.6! (Don't try until we're done with Part10, since FPM won't properly work until then!)


### Repeat the process for PHP7 with the following settings:
#### Name: ``PHP72``

### FCGI tab
#### Path to the PHP FCGI binary          : ``/opt/remi/php73/root/usr/bin/php-cgi``
#### Path to the php.ini directory        : ``/etc/opt/remi/php73``

### PHP FPM tab
#### Path to the PHP-FPM init script      : ``/opt/remi/php73/root/usr/sbin/php-fpm``
#### Path to the php.ini directory        : ``/etc/opt/remi/php73``
#### Path to the PHP-FPM pool directory   : ``/etc/opt/remi/php73/php-fpm.d``
