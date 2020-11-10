# https://packages.microsoft.com/config/rhel/7/
wget https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo -O /etc/yum.repos.d/mssql-server-2017.repo
yum -y install expect
yum -y install mssql-server
sudo /opt/mssql/bin/mssql-conf setup
#Enter your edition(1-8):
3
#Choose the language for SQL Server:
1
#Enter the SQL Server system administrator password:
Pass1234

