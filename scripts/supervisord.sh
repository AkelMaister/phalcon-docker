#!/bin/sh

if [ ! -z ${SUPERVISORD_PATH+x} ] && [ "$SUPERVISORD_PATH" != "" ]; then
        echo "env SUPERVISORD: including configurations from [ $SUPERVISORD_PATH ]"

        sed -i "/files = /d"                /etc/supervisord.conf
        echo "files = $SUPERVISORD_PATH" >> /etc/supervisord.conf

        /usr/bin/supervisord
fi
