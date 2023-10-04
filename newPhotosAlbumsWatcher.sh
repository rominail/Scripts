#!/usr/bin/sh
# Check for folders in source folder but not in destination folder (not recursively) excluding folders in the exclude file

USER=$(whoami)
sourceDir="/home/$USER/Photos"
destDir="/home/$USER/Photos selection"
findResultSource="/tmp/findResultSource.txt"
findResultDest="/tmp/findResultDest.txt"
missingFolders="/tmp/missingFolders.txt"
dirToIgnoreFile=".dirToIgnoreWatcher.txt"
dirToIgnorePath="${sourceDir}/${dirToIgnoreFile}"
sortedDirToIgnore="/tmp/dirToIgnore.txt"

cd $sourceDir
find "$sourceDir" -maxdepth 1 -type d | sed "s|${sourceDir}||g" > $findResultSource
find "$destDir" -maxdepth 1 -type d | sed "s|${destDir}||g" > $findResultDest
diff $findResultSource $findResultDest | grep '^< /\w' | sed "s|< ||g" | sort > $missingFolders
sort $dirToIgnorePath > $sortedDirToIgnore
diff $missingFolders $sortedDirToIgnore | grep '^< /\w' | sed "s|< ||g"

rm $findResultSource
rm $findResultDest
rm $missingFolders
rm $sortedDirToIgnore

exit 0
