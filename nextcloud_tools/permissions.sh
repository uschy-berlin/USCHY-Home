#!/bin/bash
find /var/www/ -type f -print0 | xargs -0 chmod 0640
find /var/www/ -type d -print0 | xargs -0 chmod 0750
chown -R www-data:www-data /var/www/
chown -R www-data:www-data /upload_tmp/
chown -R www-data:www-data /var/nc_data/
chmod 0644 /var/www/nextcloud/.htaccess
chmod 0644 /var/www/nextcloud/.user.ini
chmod 600 /etc/letsencrypt/live/oc.uschy-berlin.de/fullchain.pem
chmod 600 /etc/letsencrypt/live/oc.uschy-berlin.de/privkey.pem
chmod 600 /etc/letsencrypt/live/oc.uschy-berlin.de/chain.pem
chmod 600 /etc/letsencrypt/live/oc.uschy-berlin.de/cert.pem
chmod 600 /etc/ssl/certs/dhparam.pem
exit 0
