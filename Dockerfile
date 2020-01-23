FROM php:7.3-alpine

ENV PHALCON_VERSION=3.4.5
ENV AMQP_VERSION=1.9.4

RUN apk add --no-cache libzip-dev postgresql-dev rabbitmq-c-dev icu-dev composer git \
 && apk add --no-cache --virtual .build-dependencies curl-dev zlib-dev ${PHPIZE_DEPS} \
 && docker-php-ext-configure intl \
 && docker-php-ext-install zip curl mbstring pdo pdo_pgsql intl \
 && curl -L -o /tmp/amqp.tar.gz https://pecl.php.net/get/amqp-${AMQP_VERSION}.tgz \
 && tar xfz /tmp/amqp.tar.gz \
 && rm -f /tmp/amqp.tar.gz \
 && mkdir -p /usr/src/php/ext/amqp \
 && mv amqp-${AMQP_VERSION} /usr/src/php/ext/amqp \
 && cd /usr/src/php/ext/amqp/amqp-${AMQP_VERSION} \
 && phpize \
 && ./configure --with-amqp \
 && make \
 && make install \
 && cp -a /usr/src/php/ext/amqp/amqp-${AMQP_VERSION}/. /usr/src/php/ext/amqp/ \
 && docker-php-ext-install amqp \
 && rm -rf /usr/src/php \
 && curl -L -o /tmp/phalcon.tar.gz https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
 && tar xzf /tmp/phalcon.tar.gz -C /tmp \
 && rm -f /tmp/phalcon.tar.gz \
 && cd /tmp/cphalcon-${PHALCON_VERSION}/build \
 && sh install \
 && echo "extension=phalcon.so" > $PHP_INI_DIR/conf.d/phalcon.ini \
 && rm -rf /tmp/cphalcon-* \
 && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
 && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
 && mkdir -p /tmp/blackfire \
 && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
 && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
 && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz \
 && rm -rf /var/cache/apk/* \
 && apk del .build-dependencies

COPY ./docker-php-entrypoint /usr/local/bin/docker-php-entrypoint
