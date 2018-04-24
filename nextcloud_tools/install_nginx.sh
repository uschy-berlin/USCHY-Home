cd /usr/local/src
apt update && apt upgrade -y
apt install software-properties-common python-software-properties zip unzip screen curl ffmpeg libfile-fcntllock-perl -y
wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
vi /etc/apt/sources.list.d/nginx.list
