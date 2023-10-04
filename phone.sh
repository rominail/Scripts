#!/bin/bash
# Fetch in a vcf file people number matching the name given in argument

RESULT=`cat /home/robby/Documents/Contacts.vcf | grep -i -e ":.*$1" -B 1 -A 5`
NOM=`echo "$RESULT" | grep 'FN' | cut -d':' -f2`
TEL=`echo "$RESULT" | grep 'TEL' | cut -d':' -f2 | sed 's/ //g'`
RESULT_CLEANED=`printf "$RESULT\t\n" | grep -e 'TEL[;:]' -e 'FN:' -e 'N:' | cut -d':' -f2 | sed 's/[ ;]//g'`

printf "$RESULT_CLEANED\t\n"
#printf " ------ \t\n"
#printf "$NOM\t\n"
#printf " ------ \t\n"
#printf "$TEL\t\n"

RESULT=
NOM=
TEL=
RESULT_CLEANED=

exit 0
