#!/bin/bash
#ref: http://eveino.com/53.html 

checkphpfpm=`pgrep php-fpm`
 
if [ -n "$checkphpfpm" ]; then
exit
else
/etc/init.d/php5.6-fpm restart
fi
