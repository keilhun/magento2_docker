FROM php:7.3-fpm

RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/
COPY php.ini /usr/local/etc/php/