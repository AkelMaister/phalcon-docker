#!/bin/sh

# Create symbolic link for env file
if [ "$ENV_SYMLINK_ENABLE" == "true" ]; then
    echo "Create symlink from ${ENV_SYMLINK_SRC:-/vault/secrets/env} to ${ENV_SYMLINK_DST:-/app/.env}"
    ln -s ${ENV_SYMLINK_SRC:-/vault/secrets/env} ${ENV_SYMLINK_DST:-/app/.env}
    echo "Exit with code: $?"
fi
