FROM php:7.2.24-apache
LABEL maintainer="gizmotronic@gmail.com"

RUN apt-get update \
 && a2enmod rewrite \
 && a2enmod dav \
 && a2enmod dav_fs \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
        libpcre3-dev \
        default-mysql-client \
        zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-source extract \
 && mkdir -p /usr/src/php/ext/igbinary \
 && curl -LsSo - "https://github.com/igbinary/igbinary/archive/master.tar.gz" | \
    tar -xzC /usr/src/php/ext/igbinary --strip 1 \
 && mkdir -p /usr/src/php/ext/phpredis \
 && curl -LsSo - "https://github.com/phpredis/phpredis/archive/5.0.2.tar.gz" | \
    tar -xzC /usr/src/php/ext/phpredis --strip 1 \
 && docker-php-ext-configure igbinary \
 && docker-php-ext-install -j$(nproc) \
        igbinary \
        mysqli \
        opcache \
        zip \
 && docker-php-ext-configure phpredis --enable-redis-igbinary \
 && docker-php-ext-install -j$(nproc) \
        phpredis \
 && docker-php-source delete

EXPOSE 80
