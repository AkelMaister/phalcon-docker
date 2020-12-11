#!/bin/sh

# enable blackfire if needed
if [ "$XDEBUG_ENABLE" == "true" ]; then
    echo "zend_extension=$(php-config --extension-dir)/xdebug.so" > $(php-config --ini-dir)/xdebug.ini
fi
