# Check https://hub.docker.com/_/php/ for updates.
FROM php:8.0-fpm-buster

# PHP8 + Nginx
RUN docker-php-source extract \
    && apt-get update \
    # System Binaries (Note: SQLITE Not Required if adding a proper RDS instance)
    && apt-get -y --no-install-recommends install \
        supervisor \
        nginx \
        sqlite \
        vim \
        zip \
        make \
        htop \
        nano \
        libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
    # PHP Extensions
    && docker-php-ext-install \
        pdo_mysql \
        bcmath \
        zip \
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
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Make init script executable, build symfony, then chown everything to www-data user
RUN chmod 755 /exec-init.sh && \
    cd /var/www/app && make build-deploy && \
    chown -R www-data:www-data /var/www/app && \
    rm /usr/local/bin/composer

# This is the initial script that runs when the container is first fired up
CMD ["/exec-init.sh"]