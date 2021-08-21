# Check https://hub.docker.com/_/php/ for updates.
# Note: Installing php extensions is not trival...
FROM php:8.0-fpm-buster

# PHP8 + Nginx = #StillWinning
RUN docker-php-source extract \
    && apt-get update \
    # System Binaries
    && apt-get -y --no-install-recommends install \
        nginx \
        vim \
        make \
        htop \
        nano \
        libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    # PHP Extensions
    && docker-php-ext-install \
        pdo_mysql \
        bcmath \
        intl \
        opcache \
    && docker-php-source delete \
    # Cleanup
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Point all the logs to route out of the docker container to the docker engine
RUN ln -sf /proc/1/fd/1 /var/log/nginx/access.log && \
    ln -sf /proc/1/fd/2 /var/log/nginx/error.log && \
    ln -sf /proc/1/fd/1 /var/log/nginx/www_access.log && \
    ln -sf /proc/1/fd/2 /var/log/nginx/www_error.log

# Kill stuff that we don't need
RUN rm -rf /etc/nginx/sites-enabled/default /var/www/html

# Prod php.ini
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Add/Override files in container
ADD files/ /

# Set working directory when we jump into the container
WORKDIR /var/www/app

# We'll assume that port 80 and 443 are gonna be the web server ports
EXPOSE 80 443

# get composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# Make init script executable, build symfony, then chown everything to www-data user
RUN chmod 755 /exec-init.sh && \
    cd /var/www/app && make build-deploy && \
    chown -R www-data:www-data /var/www/app && \
    rm /usr/local/bin/composer

# This is the initial script that runs when the container is first fired up
CMD ["/exec-init.sh"]