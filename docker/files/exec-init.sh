#!/usr/bin/env bash

# update permissions
#chown -R www-data:www-data /var/www/app

#Self signed SSL cert for nginx https
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj '/CN=*.example.local/O=OGP/C=US'

# supervisord start
exec supervisord -n -c /etc/supervisor/supervisord.conf