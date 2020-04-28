FROM php:7.4.5-fpm-alpine

ENV AMQP_VERSION=1.9.4
ENV PSR_VERSION=0.7.0
ENV PHALCON_VERSION=4.0.0

RUN apk add --no-cache libzip-dev postgresql-dev rabbitmq-c-dev icu-dev git \
 && apk add --no-cache --virtual .build-dependencies curl-dev zlib-dev ${PHPIZE_DEPS} \
 && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && php -r "unlink('composer-setup.php');" \
 && curl -L -o /tmp/amqp.tar.gz https://pecl.php.net/get/amqp-${AMQP_VERSION}.tgz \
 && tar xfz /tmp/amqp.tar.gz -C /tmp \
 && rm -f /tmp/amqp.tar.gz \
 && mkdir -p /usr/src/php/ext/amqp \
 && mv /tmp/amqp-${AMQP_VERSION}/* /usr/src/php/ext/amqp \
 && rm -rf /tmp/amqp-${AMQP_VERSION} \
 && curl -L -o /tmp/php-psr.tar.gz https://github.com/jbboehr/php-psr/archive/v${PSR_VERSION}.tar.gz \
 && tar xzf /tmp/php-psr.tar.gz -C /tmp \
 && rm -f /tmp/php-psr.tar.gz \
 && mkdir -p /usr/src/php/ext/php-psr \
 && mv /tmp/php-psr-${PSR_VERSION}/* /usr/src/php/ext/php-psr \
 && rm -rf /tmp/php-psr-${PSR_VERSION} \
 && curl -sSL -o /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
 && chmod +x /usr/local/bin/install-php-extensions \
 && /usr/local/bin/install-php-extensions decimal zip pdo pdo_pgsql intl amqp php-psr bcmath \
 && rm -f /usr/local/bin/install-php-extensions \
 && rm -rf /usr/src/php \
 && curl -L -o /tmp/phalcon.tar.gz https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
 && tar xzf /tmp/phalcon.tar.gz -C /tmp \
 && rm -f /tmp/phalcon.tar.gz \
 && cd /tmp/cphalcon-${PHALCON_VERSION}/build \
 && sh install \
 && echo "extension=phalcon.so" > $PHP_INI_DIR/conf.d/90-phalcon.ini \
 && rm -rf /tmp/cphalcon-* \
 && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
 && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
 && mkdir -p /tmp/blackfire \
 && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
 && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
 && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz \
 && rm -rf /var/cache/apk/* \
 && apk del .build-dependencies

RUN apk add --no-cache supervisor

COPY scripts/* /usr/local/bin/

RUN chmod +x /usr/local/bin/*
