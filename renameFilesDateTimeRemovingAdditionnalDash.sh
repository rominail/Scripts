#!/usr/bin/sh
# For my videos & photos named with a dash between the date and time rename them without it eg. 2020-12-31-10-05-54 => 2020-12-31 10-05-54

i=0
find . -name '[0123456789][0123456789][0123456789][0123456789]-[0123456789][0123456789]-[0123456789][0123456789]-[0123456789][0123456789]-[0123456789][0123456789]-[0123456789][0123456789]*' | while read file; do
    echo "Handling ${file}"
#    file_ext=${file##*.}
    newName=$(echo "$(basename "${file}")" | sed -r "s/^([0-9]{4}-[0-9]{2}-[0-9]{2})-([0-9]{2}-[0-9]{2}-[0-9]{2})/\1 \2/")
    newFile="${file%/*}/${newName}"
	echo "mv \"${file}\" \"${newFile}\""
	mv "${file}" "${newFile}"
	
	# Safe guard to batch max 10
	#i=$(expr $i + 1)
	#echo $i
	#if [ $i -eq 10 ]; then
   		#exit
	#fi
    echo
done

