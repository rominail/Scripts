#!/bin/sh
# A script (for my dad) to fetch in the right directories of an sd card the photos and videos from a camera

SD_PATH="/media/$USER/disk/"
PHOTOS="DCIM/*/*"
VIDEOS="PRIVATE/AVCHD/BDMV/STREAM/*"
BACKUP_DIR="~/Bureau/copie_photo/"
mv $SD_PATH$PHOTOS $BACKUP_DIR
mv $SD_PATH$VIDEOS $BACKUP_DIR
exit 0
