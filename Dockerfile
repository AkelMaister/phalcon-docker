FROM php:7.3-fpm-alpine

ENV PHALCON_VERSION=3.4.5

RUN apk add --no-cache libzip-dev postgresql-dev rabbitmq-c-dev icu-dev && \
    apk add --no-cache --virtual .build-dependencies curl-dev zlib-dev ${PHPIZE_DEPS} && \
    docker-php-ext-configure intl && \
    docker-php-ext-install zip curl mbstring pdo pdo_pgsql intl && \
    curl -L -o /tmp/amqp.tar.gz https://pecl.php.net/get/amqp-1.9.4.tgz && \
    tar xfz /tmp/amqp.tar.gz && \
    rm -f /tmp/amqp.tar.gz && \
    mkdir -p /usr/src/php/ext/amqp && \
    mv amqp-1.9.4 /usr/src/php/ext/amqp && \
    cd /usr/src/php/ext/amqp/amqp-1.9.4 && \
    phpize && \
    ./configure --with-amqp && \
    make && \
    make install && \
    cp -a /usr/src/php/ext/amqp/amqp-1.9.4/. /usr/src/php/ext/amqp/ && \
    docker-php-ext-install amqp && \
    rm -rf /usr/src/php && \
    curl -L -o /tmp/phalcon.tar.gz https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
    tar xzf /tmp/phalcon.tar.gz -C /tmp && \
    rm -f /tmp/phalcon.tar.gz && \
    cd /tmp/cphalcon-${PHALCON_VERSION}/build && \
    sh install && \
    echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
    rm -rf /tmp/cphalcon-* && \
    rm -rf /var/cache/apk/* && \
    apk del .build-dependencies

RUN apk add --no-cache composer
