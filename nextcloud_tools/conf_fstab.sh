sed -i '$atmpfs /tmp tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777 0 0' /etc/fstab
sed -i '$atmpfs /var/tmp tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777 0 0' /etc/fstab
sed -i '$atmpfs /usr/local/tmp/cache tmpfs defaults,size=250M,noatime,nosuid,nodev,noexec,mode=1777 0 0' /etc/fstab
sed -i '$atmpfs /usr/local/tmp/sessions tmpfs defaults,size=250M,noatime,nosuid,nodev,noexec,mode=1777 0' /etc/fstab
