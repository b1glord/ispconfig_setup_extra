#!/usr/bin/env bash
#---------------------------------------------------------------------
# certbot.sh
#
# ISPConfig 3 centos7 certbot installer
#
# Script: certbot.sh
# Version: 1.0.0
# Author: BigLorD <furytr@yandex.com>
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------
# https://www.howtoforge.com/how-to-install-laravel-based-pyrocms-with-nginx-on-centos-7/

#### Step 3 - Install Acme.sh client and obtain Let's Encrypt certificate (optional)
#### Securing your website with HTTPS is not necessary, but it is a good practice to secure your site traffic. In order to obtain an SSL certificate from Let's Encrypt we will use Acme.sh client. Acme.sh is a pure UNIX shell software for obtaining SSL certificates from Let's Encrypt with zero dependencies. 

####Download and install acme.sh:

```
sudo su - root
git clone https://github.com/Neilpang/acme.sh.git
cd acme.sh 
./acme.sh --install --accountemail your_email@example.com
source ~/.bashrc
cd ~
```
#### Check acme.sh version:
```
acme.sh --version
# v2.8.1
```
#### Obtain RSA and ECC/ECDSA certificates for your domain/hostname:

```
# RSA 2048
acme.sh --issue --standalone -d example.com --keylength 2048
# ECDSA
acme.sh --issue --standalone -d example.com --keylength ec-256
```
#### If you want fake certificates for testing you can add --staging flag to the above commands.

#### To list your issued certs you can run:
```
acme.sh --list
```
#### Create a directory to store your certs. We will use /etc/letsencrypt directory.
```
mkdir -p /etc/letsencrypt/example.com
sudo mkdir -p /etc/letsencrypt/example.com_ecc
```
#### Install/copy certificates to /etc/letsencrypt directory.
```
# RSA
acme.sh --install-cert -d example.com \ 
        --cert-file /etc/letsencrypt/example.com/cert.pem \
        --key-file /etc/letsencrypt/example.com/private.key \
        --fullchain-file /etc/letsencrypt/example.com/fullchain.pem \
        --reloadcmd "sudo systemctl reload nginx.service"

# ECC/ECDSA
acme.sh --install-cert -d example.com --ecc \
        --cert-file /etc/letsencrypt/example.com_ecc/cert.pem \
        --key-file /etc/letsencrypt/example.com_ecc/private.key \
        --fullchain-file /etc/letsencrypt/example.com_ecc/fullchain.pem \
        --reloadcmd "sudo systemctl reload nginx.service"
```
#### After running the above commands, your certificates and keys will be in:

#### For RSA: /etc/letsencrypt/example.com directory.
#### For ECC/ECDSA: /etc/letsencrypt/example.com_ecc directory.
#### All the certificates will be automatically renewed every 60 days.

#### After obtaining certs, exit from root user and return back to normal sudo user:

#### exit
