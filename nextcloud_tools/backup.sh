#!/bin/bash
CURRENT_TIME_FORMAT="%d.%m.%Y"
BACKUP_FOLDER=/backup
FOLDERS_TO_BACKUP=(
   "/root/"
   "/etc/apticron/"
   "/etc/fail2ban/"
   "/etc/letsencrypt/"
   "/etc/logwatch/"
   "/etc/mysql/"
   "/etc/nginx/"
   "/etc/php/"
   "/etc/postfix/"
   "/etc/ssh/"
   "/etc/ssl/"
   "/usr/share/logwatch/"
   "/var/www/"
)
ARCHIVE_FILE="$BACKUP_FOLDER/backup_$(date +$CURRENT_TIME_FORMAT).tar.gz"
echo "-------------------------------------"
echo "START: $(date)"
echo "-------------------------------------"
cd $BACKUP_FOLDER
for FOLDER in ${FOLDERS_TO_BACKUP[@]}
  do
    if [ -d "$FOLDER" ];
    then
      echo "Copying $FOLDER..."
      rsync -AaRx --delete $FOLDER $BACKUP_FOLDER
    else
      echo "Skipping $FOLDER since it does not exist"
  fi
  done
echo "Copying fstab..."
cp /etc/fstab $BACKUP_FOLDER/etc/
echo "Creating SQL Dumps:"
echo " - Nextcloud..."
mysqldump --lock-tables -unextcloud -pnextcloud nextcloud --add-drop-table --allow-keywords --complete-insert --quote-names | gzip -c > $BACKUP_FOLDER/nextcloud.sql.gz
# echo " - Roundcube..."
# mysqldump --lock-tables -uroundCube -p!YourPassword2~ roundcube --add-drop-table --allow-keywords --complete-insert --quote-names | gzip -c > $BACKUP_FOLDER/RoundCube.sql.gz
# echo " - WordPress..."
# mysqldump --lock-tables -uwordpress -p!YourPassword3~ wordpress --add-drop-table --allow-keywords --complete-insert --quote-names | gzip -c > $BACKUP_FOLDER/wordpress.sql.gz
echo "Creating archive $ARCHIVE_FILE..."
mkdir -p $(dirname $ARCHIVE_FILE)
tar -czf $ARCHIVE_FILE .
chmod -R 600 $BACKUP_FOLDER
echo "Size of archive: $(stat --printf='%s' $ARCHIVE_FILE | numfmt --to=iec)"
echo "-------------------------------------"
echo "Cleaning up..."
rm $BACKUP_FOLDER/nextcloud.sql.gz
# rm $BACKUP_FOLDER/RoundCube.sql.gz
# rm $BACKUP_FOLDER/wordpress.sql.gz
rm $BACKUP_FOLDER/etc/fstab
echo "Delete backups older than 5 days..."
ls -1 -S --sort=time $BACKUP_FOLDER | tail -n +6 | xargs rm
echo "-------------------------------------"
echo "END: $(date)"
echo "-------------------------------------"
mail -s "Backup - $(date +$CURRENT_TIME_FORMAT)" -a "From: Webmaster <webmaster@schitkowsky.de>" webmaster@schitkowsky.de < $BACKUP_FOLDER/backup.txt
exit 0
