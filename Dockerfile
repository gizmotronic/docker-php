FROM php:7.1.1-apache

RUN apt-get update \
    && a2enmod rewrite \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-source extract \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-source delete
