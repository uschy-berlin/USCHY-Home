#service stop nginx
#certbot certonly --standalone -d oc.uschy-berlin.de -d www.uschy-berlin.de -d jira.uschy-berlin.de
#service start nginx
letsencrypt certonly -a webroot --webroot-path=/var/www/letsencrypt --rsa-key-size 4096 -d oc.uschy-berlin.de -d jira.uschy-berlin.de -d www.uschy-berlin.de
