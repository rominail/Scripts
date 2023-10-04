#!/bin/bash
# Backup with date of rambox playlists

USER=$(whoami)
BACKUP_NAME="rhythmbox-playlists.xml"
BACKUP_DIR="/home/$USER/Documents/backup/data/rhythmbox/"
DATE=`date '+%Y-%m-%d_%H:%M:%S'`
EXPORT_PATH=$BACKUP_DIR
EXPORT_FILE=$EXPORT_PATH$DATE$BACKUP_NAME
PLAYLIST_FILE="/home/$USER/.local/share/rhythmbox/playlists.xml"
mkdir -p $EXPORT_PATH
cp $PLAYLIST_FILE $EXPORT_FILE
exit 0
