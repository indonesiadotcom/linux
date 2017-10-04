#!/bin/bash

#VARIABLE
echo 'setup variables' && sleep 1
script=/data/scripts
client=higienis
host=$client.testingnow.me

#PREQUISITES
echo 'setup prequisites' && sleep 1
echo 'setup swap at /swap (only for development server)' && sleep 1
dd if=/dev/zero of=/swap bs=1024k count=3000
chmod 0600 /swap && mkswap /swap && swapon /swap
echo 'disable selinux' && sleep 1
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
echo 'set localtime to WIB' && sleep 1
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
echo 'install tmux git' && sleep 1
yum install tmux git
mkdir -p $script && cd $script
echo 'clone linux scripts' && sleep 1
git clone https://github.com/indonesiadotcom/linux.git
adduser $client
su - client
ssh-keygen -t rsa -b 2048 -C $client@$host
cp .ssh/id_rsa.pub .ssh/authorized_keys
chmod 0600 .ssh/authorized_keys
crontab -e
#* * * * * /usr/bin/php /home/higienis/site/current/bin/magento cron:run | grep -v "Ran jobs by schedule" >> /home/higienis/site/current/var/log/magento.cron.log
#* * * * * /usr/bin/php /home/higienis/site/current/update/cron.php >> /home/higienis/site/current/var/log/update.cron.log
#* * * * * /usr/bin/php /home/higienis/site/current/bin/magento setup:cron:run >> /home/higienis/site/current/var/log/setup.cron.log

#INSTALL NGINX
cp $script/linux/etc/yum.repos.d/nginx.repo /etc/yum.repos.d/
yum install nginx

#INSTALL PERCONA
yum install https://www.percona.com/redir/downloads/percona-release/redhat/latest/percona-release-0.1-4.noarch.rpm
yum -y install Percona-Server-server-57
#percona change pwd must be with special char and upper case
#ref percona 5.7 change root password
#https://www.percona.com/blog/2016/03/16/change-user-password-in-mysql-5-7-with-plugin-auth_socket/

#INSTALL ELASTICSEARCH
yum install java-1.8.0-openjdk
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cp $script/linux/etc/yum.repos.d/elasticsearch.repo /etc/yum.repos.d/
yum install elasticsearch
cd /usr/share/elasticsearch
bin/plugin install analysis-phonetic
bin/plugin install analysis-icu
echo 'script.inline: on' >> /etc/elasticsearch/elasticsearch.yml
echo 'script.indexed: on' >> /etc/elasticsearch/elasticsearch.yml
systemctl enable elasticsearch
systemctl start elasticsearch

#INSTALL PHP 7.0
yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm
yum -y update
yum -y install php70u-cli php70u-fpm php70u-soap php70u-pdo php70u-mysqlnd php70u-opcache php70u-xml php70u-mcrypt php70u-gd php70u-intl php70u-mbstring php70u-bcmath php70u-json php70u-iconv
sed -i 's/memory_limit = 128M/memory_limit = 2048M/g' /etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/zlib.output_compression = Off/zlib.output_compression = On/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Jakarta/g' /etc/php.ini

#INSTALL COMPOSER
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer



