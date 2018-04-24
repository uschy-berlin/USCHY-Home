apt update && apt upgrade && apt dist-upgrade
apt install logrotate geoip-database libgeoip-dev libgeoip1
cd /usr/share/GeoIP
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
mv GeoIP.dat GeoIP.dat.bak
gunzip GeoIP.dat.gz
cd /usr/local/src/nginx
wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
apt update
apt build-dep nginx -y
apt source nginx
mkdir nginx-1.13.0/debian/modules -p
cd nginx-1.13.0/debian/modules
wget https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz
tar -zxvf 2.3.tar.gz
cd ..
ll
