#!/usr/bin/env bash
#---------------------------------------------------------------------
# install_hhvm_facebook.sh
#
# ISPConfig 3 centos7 hhvm facebook installer
#
# Script: install_hhvm_facebook.sh
# Version: 1.0.0
# Author: BigLorD <furytr@yandex.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------
# Ref https://github.com/facebook/hhvm/wiki/Building-and-installing-hhvm-on-CentOS-7.x

# Use the following shell script to compile HHVM on CentOS 7.x

# Need to be ran under root priv or you can sudo it
# Update your CentOS first
yum -y update

# Enable the EPEL repository
yum -y install epel-release

# Install some dependencies 
yum -y install cpp gcc-c++ cmake3 git psmisc {binutils,boost,jemalloc,numactl}-devel \
{ImageMagick,sqlite,tbb,bzip2,openldap,readline,elfutils-libelf,gmp,lz4,pcre}-devel \
lib{xslt,event,yaml,vpx,png,zip,icu,mcrypt,memcached,cap,dwarf}-devel \
{unixODBC,expat,mariadb}-devel lib{edit,curl,xml2,xslt}-devel \
glog-devel oniguruma-devel ocaml gperf enca libjpeg-turbo-devel openssl-devel \
mariadb mariadb-server {fastlz,double-conversion,re2}-devel make

# Optional dependencies (these extensions are not built by default)
yum -y install {fribidi,libc-client,glib2}-devel

# Get our hhvm
cd /tmp
git clone https://github.com/facebook/hhvm -b master  hhvm  --recursive
cd hhvm

#We have to run. 
./configure

# Okay let's go
cmake3 .
# Multithreads compiling
#make -j$(($(nproc)+1))
make
# Compiled?
./hphp/hhvm/hhvm --version
# Install it
make install
# Final
hhvm --version

# https://github.com/facebook/hhvm/blob/master/patches/0001-Don-t-require-readline-zstd-if-not-building-client-s.patch
