cp /etc/php/7.2/fpm/pool.d/www.conf /etc/php/7.2/fpm/pool.d/www.conf.bak
cp /etc/php/7.2/cli/php.ini /etc/php/7.2/cli/php.ini.bak
cp /etc/php/7.2/fpm/php.ini /etc/php/7.2/fpm/php.ini.bak
cp /etc/php/7.2/fpm/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf.bak
sed -i "s/;env\[HOSTNAME\] = /env[HOSTNAME] = /" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/;env\[TMP\] = /env[TMP] = /" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/;env\[TMPDIR\] = /env[TMPDIR] = /" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/;env\[TEMP\] = /env[TEMP] = /" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/;env\[PATH\] = /env[PATH] = /" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/pm.max_children = .*/pm.max_children = 240/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/pm.start_servers = .*/pm.start_servers = 20/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/pm.min_spare_servers = .*/pm.min_spare_servers = 10/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/pm.max_spare_servers = .*/pm.max_spare_servers = 20/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/;pm.max_requests = 500/pm.max_requests = 500/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/output_buffering =.*/output_buffering = Off/" /etc/php/7.2/cli/php.ini
sed -i "s/max_execution_time =.*/max_execution_time = 1800/" /etc/php/7.2/cli/php.ini
sed -i "s/max_input_time =.*/max_input_time = 3600/" /etc/php/7.2/cli/php.ini
sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/7.2/cli/php.ini
sed -i "s/;upload_tmp_dir =.*/upload_tmp_dir = \/upload_tmp/" /etc/php/7.2/cli/php.ini
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/7.2/cli/php.ini
sed -i "s/max_file_uploads =.*/max_file_uploads = 100/" /etc/php/7.2/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/\Berlin/" /etc/php/7.2/cli/php.ini
sed -i "s/;session.cookie_secure.*/session.cookie_secure = True/" /etc/php/7.2/cli/php.ini
sed -i "s/;session.save_path =.*/session.save_path = \"\/usr\/local\/tmp\/sessions\"/" /etc/php/7.2/cli/php.ini
sed -i '$aapc.enable_cli = 1' /etc/php/7.2/cli/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
sed -i "s/output_buffering =.*/output_buffering = Off/" /etc/php/7.2/fpm/php.ini
sed -i "s/max_execution_time =.*/max_execution_time = 1800/" /etc/php/7.2/fpm/php.ini
sed -i "s/max_input_time =.*/max_input_time = 3600/" /etc/php/7.2/fpm/php.ini
sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/7.2/fpm/php.ini
sed -i "s/;upload_tmp_dir =.*/upload_tmp_dir = \/upload_tmp/" /etc/php/7.2/fpm/php.ini
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/7.2/fpm/php.ini
sed -i "s/max_file_uploads =.*/max_file_uploads = 100/" /etc/php/7.2/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/\Berlin/" /etc/php/7.2/fpm/php.ini
sed -i "s/;session.cookie_secure.*/session.cookie_secure = True/" /etc/php/7.2/fpm/php.ini
sed -i "s/;opcache.enable=.*/opcache.enable=1/" /etc/php/7.2/fpm/php.ini
sed -i "s/;opcache.enable_cli=.*/opcache.enable_cli=1/" /etc/php/7.2/fpm/php.ini
sed -i "s/;opcache.memory_consumption=.*/opcache.memory_consumption=128/" /etc/php/7.2/fpm/php.ini
sed -i "s/;opcache.interned_strings_buffer=.*/opcache.interned_strings_buffer=8/" /etc/php/7.2/fpm/php.ini
sed -i "s/;opcache.max_accelerated_files=.*/opcache.max_accelerated_files=10000/" /etc/php/7.2/fpm/php.ini
sed -i "s/;opcache.revalidate_freq=.*/opcache.revalidate_freq=1/" /etc/php/7.2/fpm/php.ini
sed -i "s/;opcache.save_comments=.*/opcache.save_comments=1/" /etc/php/7.2/fpm/php.ini
sed -i "s/;session.save_path =.*/session.save_path = \"\/usr\/local\/tmp\/sessions\"/" /etc/php/7.2/fpm/php.ini
sed -i "s/;emergency_restart_threshold =.*/emergency_restart_threshold = 10/" /etc/php/7.2/fpm/php-fpm.conf
sed -i "s/;emergency_restart_interval =.*/emergency_restart_interval = 1m/" /etc/php/7.2/fpm/php-fpm.conf
sed -i "s/;process_control_timeout =.*/process_control_timeout = 10s/" /etc/php/7.2/fpm/php-fpm.conf
