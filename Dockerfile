FROM php:7.1.8-apache

RUN apt-get update \
    && a2enmod rewrite \
    && a2enmod dav \
    && a2enmod dav_fs \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client libpcre3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-source extract \
    && docker-php-ext-install -j$(nproc) mysqli opcache \
    && docker-php-source delete

VOLUME [ "/etc/apache2", "/var/www/html" ]

EXPOSE 80
