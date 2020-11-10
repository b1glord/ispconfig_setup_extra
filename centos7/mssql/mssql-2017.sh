# https://packages.microsoft.com/config/rhel/7/
wget https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo -O /etc/yum.repos.d/mssql-server-2017.repo

yum install mssql-server -y
