#!/bin/bash
cd /etc/letsencrypt
letsencrypt renew
result=$(find /etc/letsencrypt/live/ -type l -mtime -1 )
if [ -n "$result" ]; then
  /usr/sbin/service nginx stop
  /usr/sbin/service mysql restart
  /usr/sbin/service redis-server restart
  /usr/sbin/service php7.2-fpm restart
  /usr/sbin/service postfix restart
  /usr/sbin/service nginx restart
fi
exit 0
