#!/bin/sh

if [ ! -z ${PHP_CRONTABS_PATH+x} ] && [ "$PHP_CRONTABS_PATH" != "" ]; then
        printf "env CRONTABS_PATH: setting up crontabs: ";

        for f in ${PHP_CRONTABS_PATH}; do
                printf "$f, ";
                rm -f /etc/crontabs/${f##*/}
                cp $f /etc/crontabs/
                chmod 0600 /etc/crontabs/${f##*/}
        done

        echo
        printenv | grep -v "no_proxy" >> /etc/environment

        /usr/sbin/crond
fi
