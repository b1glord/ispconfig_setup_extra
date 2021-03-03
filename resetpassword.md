How to reset the administrator password in ISPConfig 3
by Till
If you lost your ISPConfig 3 administrator password, you can reset it with the following SQL query.

UPDATE sys_user SET passwort = md5('admin') WHERE username = 'admin';
The SQL query sets the password to "admin" for the user "admin", it has to be executed in the ISPConfig mysql database, e.g. with phpmyadmin. If you dont have phpmyadmin installed, then the query can be executed with the mysql commandline utility as well:

Login to the mysql database.

mysql -u root -p
Then enter the password of the mysql root user. To switch to the ISPConfig database, run this command:

use dbispconfig;
And execute the SQL command:

UPDATE sys_user SET passwort = md5('admin') WHERE username = 'admin';
Finally close the mysql shell:

quit;
