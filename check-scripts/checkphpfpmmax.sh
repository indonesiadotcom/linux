#!/bin/bash

when=$(date +%Y%m%d%H%M)
checkphpfpm=`ps aux | grep php | wc -l`
 
if [ $checkphpfpm -gt 200 ]; then
echo ""
echo "php connection is "$checkphpfpm" at "$when" and php-fpm auto reloaded" >> /mnt/data/scripts/checkphpfpmmax.log
echo ""
/etc/init.d/php5.6-fpm reload
sleep 3
/etc/init.d/php5.6-fpm restart
fi

