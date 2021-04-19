FROM php:7.3-fpm
ENV REFRESHED_AT 04-15-2021
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libwebp-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-jpeg-dir --with-freetype-dir --with-webp-dir \
    && docker-php-ext-install -j$(nproc) gd

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
    bc \
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
    mv composer.phar /usr/local/bin/composer && \
    composer self-update --1

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/
COPY php.ini /usr/local/etc/php/
COPY auth.json /root/.composer/auth.json