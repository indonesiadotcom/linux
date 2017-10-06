#!/bin/bash 

#VARIABLE
echo 'setup variables' && sleep 1
script=/data/scripts
client=toserbayogya
host=$client.testingnow.me

adduser $client
su - $client
mkdir .ssh
chmod 700 .ssh
ssh-keygen -t rsa -b 2048 -C $client@$host -f .ssh/id_rsa -N ''
cp .ssh/id_rsa.pub .ssh/authorized_keys
chmod 0600 .ssh/authorized_keys
crontab -e
#wait until crontab editor opened
#* * * * * /usr/bin/php /home/toserbayogya/site/current/bin/magento cron:run | grep -v "Ran jobs by schedule" >> /home/toserbayogya/site/current/var/log/magento.cron.log
#* * * * * /usr/bin/php /home/toserbayogya/site/current/update/cron.php >> /home/toserbayogya/site/current/var/log/update.cron.log
#* * * * * /usr/bin/php /home/toserbayogya/site/current/bin/magento setup:cron:run >> /home/toserbayogya/site/current/var/log/setup.cron.log
#save crontab
#exit

