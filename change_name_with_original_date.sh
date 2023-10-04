#!/bin/bash
# I'm not an 100% sure to remember what the script was for
# It seems :
# Something like change video files creation time by their name containing the date

# find specific files
files=$(find . -type f -name '*.mkv')
new_directory="/mnt/hdd/vidtmp/"

# use newline as file separator (handle spaces in filenames)
IFS=$'\n'

for file in ${files}
do
	echo "---------"
	echo $file
	
	name=$(basename "${file}" .MP4)
	crtime_timestamp=$(stat -c %W "${file}")

	tmp=$(date -d "@${crtime_timestamp}")
	echo $tmp
	tmp=$(date -d "@${crtime_timestamp}" +"%Y-%m-%d %H:%M:%S")
	tmp=$(date -d "${tmp}+5 hours" +"%Y-%m-%d %H:%M:%S")
	echo $tmp
	echo "${name} $tmp"
	# read file date from original video
	# change new file time using touch
	# change new file name with date
	#touch -t $(date -r "${file}" +%Y%m%d%H%M.%S) "${new_directory}${corresponding_file}"
	#cd ${new_directory}
	#mv "${corresponding_file}" "`date -r ${corresponding_file} "+%Y-%m-%d %H:%M:%S"` ${corresponding_file}"
	#exit
done

exit


