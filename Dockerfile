FROM php:7.4.5-fpm-alpine

ENV AMQP_VERSION=1.9.4
ENV PSR_VERSION=0.7.0
ENV PHALCON_VERSION=4.0.5

RUN apk add --no-cache libzip-dev postgresql-dev rabbitmq-c-dev icu-dev && \
    apk add --no-cache --virtual .build-dependencies curl-dev zlib-dev ${PHPIZE_DEPS} && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');" && \
    curl -L -o /tmp/amqp.tar.gz https://pecl.php.net/get/amqp-${AMQP_VERSION}.tgz && \
    tar xfz /tmp/amqp.tar.gz -C /tmp && \
    rm -f /tmp/amqp.tar.gz && \
    mkdir -p /usr/src/php/ext/amqp && \
    mv /tmp/amqp-${AMQP_VERSION}/* /usr/src/php/ext/amqp && \
    rm -rf /tmp/amqp-${AMQP_VERSION} && \
    curl -L -o /tmp/php-psr.tar.gz https://github.com/jbboehr/php-psr/archive/v${PSR_VERSION}.tar.gz && \
    tar xzf /tmp/php-psr.tar.gz -C /tmp && \
    rm -f /tmp/php-psr.tar.gz && \
    mkdir -p /usr/src/php/ext/php-psr && \
    mv /tmp/php-psr-${PSR_VERSION}/* /usr/src/php/ext/php-psr && \
    rm -rf /tmp/php-psr-${PSR_VERSION} && \
    docker-php-ext-configure amqp --with-amqp && \
    docker-php-ext-install zip pdo pdo_pgsql intl amqp php-psr && \
    rm -rf /usr/src/php && \
    curl -L -o /tmp/phalcon.tar.gz https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
    tar xzf /tmp/phalcon.tar.gz -C /tmp && \
    rm -f /tmp/phalcon.tar.gz && \
    cd /tmp/cphalcon-${PHALCON_VERSION}/build && \
    sh install && \
    echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/90-phalcon.ini && \
    rm -rf /tmp/cphalcon-* && \
    rm -rf /var/cache/apk/* && \
    apk del .build-dependencies
