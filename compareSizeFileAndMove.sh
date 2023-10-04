#!/usr/bin/sh
# After re-encoding my video files
# Keep the smallest file of the 2 versions of the file

#filelist="videosToReencode.txt"
dest="/home/$USER/Photos/"

find . -type f -name '*.mp4' -o -name '*.wmv' -o -name '*.flv' -o -name '*.webm' -o -name '*.mov' | while read file; do
    echo "Handling ${file}"
    file_ext=${file##*.}
    mkvFilename="`basename "${file}" .${file_ext}`.mkv"
    mkvFile="${file%/*}/${mkvFilename}"
    originalSize=$(wc -c < ${file})
    mkvSize=$(wc -c < ${mkvFile})
    if [ ${originalSize} -lt ${mkvSize} ]; then
    	echo "Keeping the original file, removing both tmp files"
    	echo "rm \"${file}\""
    	rm "${file}"
    	echo "rm \"${mkvFile}\""
    	rm "${mkvFile}"
    else
    	echo "Keeping the new (mkv) file"
    	echo "mv \"${mkvFile}\" \"${dest}${mkvFile}\""
    	mv "${mkvFile}" "${dest}${mkvFile}"
    	echo "rm \"${dest}${file}\""
    	rm "${dest}${file}"
    fi
    echo
done

