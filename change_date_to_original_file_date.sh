#!/bin/bash
# I'm not an 100% sure to remember what the script was for
# It seems :
# Unmounting the drive wich contains video files and change their creation time by their name containing the date

# find specific files
files=$(find . -type f -name '*.MP4')
new_directory="/mnt/hdd/vidtmp/"

# use newline as file separator (handle spaces in filenames)
IFS=$'\n'
declare -A news_inode
declare -A news_file
declare -A originals_crtime

for file in ${files}
do
	echo "---------"
	
	name=$(basename "${file}" .MP4)
	corresponding_file=$(find ${new_directory} -type f -name "*${name}.mkv")
	inode=$(stat -c %i "${corresponding_file}")
	crtime_timestamp=$(stat -c %W "${file}")

	tmp=$(date -d "@${crtime_timestamp}")
	echo $tmp
	tmp=$(date -d "@${crtime_timestamp}" +"%Y-%m-%d %H:%M:%S")
	tmp=$(date -d "${tmp}+5 hours" +"%Y-%m-%d %H:%M:%S")
	echo $tmp
	crtime_format=$(date -d "${tmp}" +"%Y%m%d%H%M%S.00")
	news_inode[$name]="${inode}"
	news_file[$name]="${corresponding_file}"
	originals_crtime[$name]="${crtime_format}"
	echo "${name} ${corresponding_file} ${news_inode[$name]} ${originals_crtime[$name]} $tmp"
	# read file date from original video
	# change new file time using touch
	# change new file name with date
	#touch -t $(date -r "${file}" +%Y%m%d%H%M.%S) "${new_directory}${corresponding_file}"
	#option : -r, --reference=FILE	use this file's times instead of current time
	#cd ${new_directory}
	#mv "${corresponding_file}" "`date -r ${corresponding_file} "+%Y-%m-%d %H:%M:%S"` ${corresponding_file}"
	#exit
done

echo
echo "Unmounting hdd"
umount /dev/sda2


for file in ${files}
do
	name=$(basename "${file}" .MP4)
	echo 'set_inode_field <'${news_inode[$name]}'> crtime '${originals_crtime[$name]}
	debugfs -w -R 'set_inode_field <'${news_inode[$name]}'> crtime '${originals_crtime[$name]} /dev/sda2
	#break
done

echo 2 > /proc/sys/vm/drop_caches

exit


