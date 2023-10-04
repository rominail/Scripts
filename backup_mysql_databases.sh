#!/bin/sh
# Backup mysql databases in a specific directory with a specific name format

BASENAME='backup_mysql_'
BACKUP_DIR="/root/mysql_backups/"
DATE=`date +%Y-%m-%d`
NAME="$BASENAME$DATE.sql"
echo "Saving mysql databases to $BACKUP_DIR$NAME";
mysqldump --all-databases > $BACKUP_DIR$NAME

exit 0

