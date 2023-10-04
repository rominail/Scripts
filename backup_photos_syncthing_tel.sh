#!/bin/bash
# Used on a directory synchronized between laptop and phone (for camera)
# Create a copy using hardlinks of the files
# Files which have been deleted from the phone are moved to a trash folder with a 1 month limit
# This script aims to protect my recent pictures from my camera to be removed if my phone get lost/stolen and the person erase everything before I stop the sync

if [ ! -d "$1" ]; then
    echo "Please provide a directory"
    exit 1
fi
backup_dir_prefix=".backup-"
trash_dir_prefix=".trash-"
todayDate=$(date "+%Y-%m-%d")
lastMonthDate=$(date -d 'last month' "+%Y-%m-%d")
cd "$1" || exit
dirs=$(find . -maxdepth 1 -type d)
# use newline as file separator (handle spaces in filenames)
IFS=$'\n'

for dir in $dirs; do
  if [ "$dir" = '.' ]; then
      continue
  fi
  dir_basename=$(basename "$dir")
  if [[ $dir_basename =~ ^${backup_dir_prefix} ]]; then
      continue
  fi
  if [[ $dir_basename =~ ^${trash_dir_prefix} ]]; then
      continue
  fi
  echo "Backing up $dir_basename"
  backup_dir="${backup_dir_prefix}${dir_basename}"
  trash_dir="${trash_dir_prefix}${dir_basename}/${todayDate}"
  mkdir -p "$backup_dir"
  mkdir -p "$trash_dir"
  echo "rsync -tbrv --delete-after --link-dest=\"$PWD/$dir_basename/\" --backup-dir=\"$PWD/${trash_dir}/\" \"$dir_basename/\" \"${backup_dir}/\""
  rsync -tbrv --delete-after --link-dest="$PWD/$dir_basename/" --backup-dir="$PWD/${trash_dir}/" "$dir_basename/" "${backup_dir}/"
  echo "Clean old trash"
  cd "${trash_dir}/.." || exit
  backup_dirs=$(find . -maxdepth 1 -type d)
  for backup_dir in $backup_dirs; do
	if [ "${backup_dir}" = '.' ]; then
	  continue
	elif [ "${backup_dir}" = '..' ]; then
	  continue
	fi
  	if expr "${lastMonthDate}" ">" "${backup_dir}" >/dev/null; then
  		echo "Removing dir \"${backup_dir}\""
  		rm -rf "${backup_dir}"
  	fi
  done
  cd "$1" || exit
done
exit 0
