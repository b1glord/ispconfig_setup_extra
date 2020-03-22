 #!/usr/bin/env bash
#---------------------------------------------------------------------
# install_github.sh
#
# ISPConfig 3 centos7 github new version installer
#
# Script: install_github.sh
# Version: 1.0.0
# Author: BigLorD <furytr@yandex.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------
 #ref https://www.howtodojo.com/2017/10/install-git-centos-7/
  echo -n "Removing Git (Old Version)... "
  yum remove -y git
  echo -n "Installing Git (New Version)... "
  yum install -y https://centos7.iuscommunity.org/ius-release.rpm
  yum install -y git2u
  git --version
