#!/bin/bash
# Backup app configuration necessiting root

USER=robby
backup_dir=/home/$USER/Documents/backup/data/
mkdir -p $backup_dir

mv $backup_dir/Preferences_Plex.xml.gpg $backup_dir/Preferences_Plex.xml.gpg.bak
cat "/var/snap/plexmediaserver/common/Library/Application Support/Plex Media Server/Preferences.xml" | su $USER -c="gpg2 -e -r 3208496504ADBD0552D31699EAD008DA5746FED5 -o $backup_dir/Preferences_Plex.xml.gpg"
[ -f $backup_dir/Preferences_Plex.xml.gpg ] && rm $backup_dir/Preferences_Plex.xml.gpg.bak

echo 'Pombo' # TODO encrypt
cp /usr/local/bin/pombo $backup_dir
cp /etc/pombo.conf $backup_dir

exit 0
