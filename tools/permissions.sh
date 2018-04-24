#!/bin/bash
find /var/www/nextcloud/ -type f -print0 | xargs -0 chmod 0640
find /var/www/nextcloud/ -type d -print0 | xargs -0 chmod 0750
chown -R www-data:www-data /var/www/
#umount /<yournas>/<yourshare>/
umount /uschy12/uschitkowsky/
chown -R www-data:www-data /data
#mount /<yournas>/<yourshare>/
mount /uschy12/uschitkowsky/
chmod 0644 /var/www/nextcloud/.htaccess
chmod 0644 /var/www/nextcloud/.user.ini
#chmod 600 /etc/letsencrypt/live/<yourcloud...>/fullchain.pem
#chmod 600 /etc/letsencrypt/live/<yourcloud...>/privkey.pem
#chmod 600 /etc/letsencrypt/live/<yourcloud...>/chain.pem
#chmod 600 /etc/letsencrypt/live/<yourcloud...>/cert.pem
#chmod 600 /etc/ssl/certs/dhparam.pem
