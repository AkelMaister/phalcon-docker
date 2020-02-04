#!/bin/sh

if [ "$PHP_COMMAND_RUN" == "true" ]; then
    echo "Run command: ${PHP_COMMAND}"
    eval ${PHP_COMMAND}
    echo "Exit with code: $?"
fi

