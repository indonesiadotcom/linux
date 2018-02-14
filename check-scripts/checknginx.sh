#!/bin/bash
 
checknginx=`pgrep nginx`
 
if [ -n "$checknginx" ]; then
exit
else
/etc/init.d/nginx restart
fi
