#!/bin/bash
# Re-encoding videos files from a file list

filelist="videosToReencode.txt"
dest="/home/robby/tmp/"
echo "reading $filelist"

while read file; do
# find . -type f -name '*.mp4' -o -name '*.wmv' -o -name '*.flv' -o -name '*.webm' -o -name '*.mov' | while read file; do
    echo "Handling ${file}"
    file_ext=${file##*.}
    fullDest="${dest}${file%/*}"
    finalFileName="`basename "$file" .$file_ext`.mkv"
    echo "Creating destination dir if needed : ${fullDest}"
    mkdir -p "${fullDest}"
    echo "Final file : ${finalFileName}"
#    ffmpeg -i "${file}" -c:v libx265 -vtag hvc1 -preset slow -x265-params crf=18 "${finalFileName}"
    ffmpeg -nostdin -i "${file}" -c:v libx265 -vtag hvc1 -preset slow -x265-params crf=18 "${fullDest}/${finalFileName}"
    ln "${file}" "${fullDest}/`basename "$file"`"
    echo
# done
done < $filelist

