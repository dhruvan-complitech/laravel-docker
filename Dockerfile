FROM php:7.2-apache
RUN apt-get update && apt-get install -y apt-utils \
    zip \
    unzip \
    git \
    nano \
    curl \
    sudo && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_mysql mysqli bcmath

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN useradd -o -u 1000 -g www-data -m -s /bin/bash www
RUN chown -R www-data:www-data /var/www

COPY src/composer.json src/composer.lock ./
RUN composer install --no-scripts --no-autoloader

# Clean up APT when done.
RUN apt-get autoremove -y
COPY ./src .
WORKDIR /var/www/html/
EXPOSE 80

CMD ["sudo", "/usr/sbin/apache2ctl", "-D", "FOREGROUND"]