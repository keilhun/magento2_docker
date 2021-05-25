ARG php_version
FROM php:${php_version}-fpm

ARG php_version
ARG magento_version

ENV REFRESHED_AT 04-15-2021
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libwebp-dev \
        bc \
        libpng-dev 
    
    # parameters for gd changed after PHP 7.4
RUN if  [ `echo "($php_version < 7.4)" | bc` = "1" ]; then docker-php-ext-configure gd --with-jpeg-dir --with-freetype-dir --with-webp-dir; else docker-php-ext-configure gd --with-jpeg --with-freetype --with-webp; fi
RUN docker-php-ext-install -j$(nproc) gd
RUN apt update && apt -y install \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    libmcrypt-dev \
    libicu-dev \
    wget \
    openssl \
    git \
    openssh-client \
    mariadb-client \
    build-essential \
    autoconf \
    automake \
    nasm \
    unzip \
    dnsutils

RUN docker-php-ext-install pdo pdo_mysql mysqli

RUN docker-php-ext-install -j$(nproc) \
    soap \
    bcmath \
    intl \
    pdo_mysql \
    simplexml \
    sockets \
    xsl \
    zip

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer

COPY version_check.php /root
RUN if  [ `php /root/version_check.php $magento_version 2.4.2` -eq "0" ]; then composer self-update --1; fi

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/
COPY php.ini /usr/local/etc/php/
COPY auth.json /root/.composer/auth.json