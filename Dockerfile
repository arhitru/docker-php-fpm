# Для начала указываем исходный образ, он будет использован как основа
FROM php:fpm
# Необязательная строка с указанием автора образа
MAINTAINER arhitru.ru <info@arhitru.ru>
 
# RUN выполняет идущую за ней команду в контексте нашего образа.
# В данном случае мы установим некоторые зависимости и модули PHP.
# Для установки модулей используем команду docker-php-ext-install.
# На каждый RUN создается новый слой в образе, поэтому рекомендуется объединять$
RUN apt-get update && apt-get install -y \
        curl \
        wget \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libonig-dev \
        libzip-dev \
        libmcrypt-dev \
        && pecl install mcrypt \
        && docker-php-ext-enable mcrypt \
        && docker-php-ext-install -j$(nproc) iconv mbstring mysqli pdo_mysql zip \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd
 
# Куда же без composer'а.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
 
# Добавим свой php.ini, можем в нем определять свои значения конфига
ADD php.ini /usr/local/etc/php/conf.d/40-custom.ini
 
# Указываем рабочую директорию для PHP
WORKDIR /var/www
 
# Запускаем контейнер
# Из документации: The main purpose of a CMD is to provide defaults for an executi$
# or they can omit the executable, in which case you must specify an ENTRYPOINT in$
CMD ["php-fpm"]
