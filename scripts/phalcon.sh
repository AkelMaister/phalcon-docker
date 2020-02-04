#!/bin/sh

# disable phalcon if needed
if [ "$PHALCON_ENABLE" == "false" ]; then
    rm -f $PHP_INI_DIR/conf.d/90-phalcon.ini
    rm -f $PHP_INI_DIR/conf.d/docker-php-ext-psr.ini
fi

