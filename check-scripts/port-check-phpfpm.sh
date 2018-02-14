#!/bin/bash

#ref: https://gist.github.com/stojg/70a15a84900da72ff2b5

function checkport {
        if nc -zv -w5 $1 $2 <<< '' &> /dev/null
        then
                sleep 1
        else
                /etc/init.d/php5.6-fpm restart
        fi
}

checkport 'localhost' 9000
