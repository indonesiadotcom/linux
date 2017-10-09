#!/bin/bash

#VARIABLE
echo 'setup variables' && sleep 1
echo 'Processing ...' && sleep 1
echo '' && sleep 1
script=/data/scripts
client=toserbayogya
host=$client.testingnow.me

#PREQUISITES
echo 'setup prequisites' && sleep 1
echo 'Processing ...' && sleep 1
echo '' && sleep 1
echo 'setup swap at /swap (only for development server)' && sleep 1
dd if=/dev/zero of=/swap bs=1024k count=3000
chmod 0600 /swap && mkswap /swap && swapon /swap

echo 'disable selinux' && sleep 1 && echo '' && sleep 1
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

echo 'set localtime to WIB' && sleep 1 && echo '' && sleep 1
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

echo 'install tmux git' && sleep 1 && echo '' && sleep 1
yum -y install tmux git
mkdir -p $script && cd $script

echo 'clone linux scripts' && sleep 1 && echo '' && sleep 1
git clone https://github.com/indonesiadotcom/linux.git

#INSTALL NGINX
echo 'setup nginx' && sleep 1
echo 'Processing ...' && sleep 1
echo '' && sleep 1
cp $script/linux/etc/yum.repos.d/nginx.repo /etc/yum.repos.d/
yum -y install nginx
systemctl enable nginx
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.ori
cp $script/linux/etc/nginx/conf.d/mag2.conf /etc/nginx/conf.d/default.conf

#INSTALL PERCONA
echo 'setup percona' && sleep 1
echo 'Processing ...' && sleep 1
echo '' && sleep 1
yum -y install https://www.percona.com/redir/downloads/percona-release/redhat/latest/percona-release-0.1-4.noarch.rpm
yum -y install Percona-Server-server-57
systemctl enable mysqld
systemctl start mysql
#more /var/log/mysqld.log
#mysql -uroot -ppwdfromvarlogmysqld.log
#alter user root@localhost identified by 'newpwd';
#flush privileges;
#percona change pwd must be with special char and upper case
#ref percona 5.7 change root password
#https://www.percona.com/blog/2016/03/16/change-user-password-in-mysql-5-7-with-plugin-auth_socket/
#create .my.cnf
#mysql -e 'create database $client'
#mysql -e 'grant all privileges on $client.* to $client@localhost identified by "pwduser"'

#INSTALL ELASTICSEARCH
echo 'setup elasticsearch' && sleep 1
echo 'Processing ...' && sleep 1
echo '' && sleep 1
yum -y install java-1.8.0-openjdk
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cp $script/linux/etc/yum.repos.d/elasticsearch.repo /etc/yum.repos.d/
yum -y install elasticsearch
cd /usr/share/elasticsearch
bin/plugin install analysis-phonetic
bin/plugin install analysis-icu
echo 'script.inline: on' >> /etc/elasticsearch/elasticsearch.yml
echo 'script.indexed: on' >> /etc/elasticsearch/elasticsearch.yml
systemctl enable elasticsearch
systemctl start elasticsearch

#INSTALL PHP 7.0
echo 'setup php 7.0' && sleep 1
echo 'Processing ...' && sleep 1
echo '' && sleep 1
yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm
yum -y update
yum -y install php70u-cli php70u-fpm php70u-soap php70u-pdo php70u-mysqlnd php70u-opcache php70u-xml php70u-mcrypt php70u-gd php70u-intl php70u-mbstring php70u-bcmath php70u-json php70u-iconv
sed -i 's/memory_limit = 128M/memory_limit = 2048M/g' /etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/zlib.output_compression = Off/zlib.output_compression = On/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Jakarta/g' /etc/php.ini
sed -i 's/user = php-fpm/user = toserbayogya/g' /etc/php-fpm.d/www.conf
sed -i 's/group = php-fpm/group = toserbayogya/g' /etc/php-fpm.d/www.conf
sed -i 's/listen = 127.0.0.1:9000/;listen = 127.0.0.1:9000/g' /etc/php-fpm.d/www.conf
sed -i 's/;listen = \/run\/php-fpm\/www.sock/listen = \/run\/php-fpm\/www.sock/g' /etc/php-fpm.d/www.conf
sed -i 's/;listen.owner = root/listen.owner = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/;listen.group = root/listen.group = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php-fpm.d/www.conf

systemctl enable php-fpm
systemctl start php-fpm

#INSTALL COMPOSER
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

#BACKUP
cp $script/linux/backup/00-backup-db.sh $script/
chmod +x $script/00-backup-db.sh
crontab -e
#0 0 * * * /data/scripts/00-backup-db.sh

