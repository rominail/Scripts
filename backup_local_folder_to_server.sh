#!/bin/bash
# Backup a folder in argument to my server
# Prevents from having several times a 5 lines long command in my crontab

confFile="${0%.*}.conf"
source $confFile

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=dfo:cvnl:
LONGOPTS=debug,force,output:,checksum,verbose,dry-run,log:

# -use ! and PIPESTATUS to get exit code with errexit set
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

d=n f=n v=n n=n c=n outFile=- logFile=""
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -d|--debug)
            d=y
            shift
            ;;
        -f|--force)
            f=y
            shift
            ;;
        -v|--verbose)
            v=y
            shift
            ;;
        -n|--dry-run)
            n=y
            shift
            ;;
        -o|--output)
            outFile="$2"
            shift 2
            ;;
        -c|--checksum)
            c=y
            shift
            ;;
        -l|--log)
            logFile="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [ ! -d "$1" ]; then
    echo "Please provide a directory"
    exit 1
fi

rsyncParams="-vahz"
if [[ "$c" = "y" ]]; then
	rsyncParams="${rsyncParams}c"
fi

if [[ "$n" = "y" ]]; then
	rsyncParams="${rsyncParams}n"
fi

logCommand=""
if [[ -n "$logFile" ]]; then
	# Doesn't work with a file containing space
	rsyncParams="${rsyncParams} --log-file=${logFile}"
fi

if [[ "$v" = "y" ]]; then
	if [[ "$n" = "y" ]]; then
		echo "Dry run"
	fi

	if [[ -n "$logFile" ]]; then
		echo "Logging rsync output to : "
		echo $logFile
	fi
	
	if [[ "$c" = "y" ]]; then
		echo "Rsync using checksum"
	fi
	
	echo "Rsync params will be :"
	echo $rsyncParams
	echo "rsync ${rsyncParams} --progress --stats --delete -e 'ssh -p 2222 -i /home/robby/.ssh/serveur_mut' \"${1%/}\" \"${distUser}@${server}:${distDir}\""
fi

rsync ${rsyncParams} --progress --stats --delete -e 'ssh -p 2222 -i /home/robby/.ssh/serveur_mut' "${1%/}" "${distUser}@${server}:${distDir}"

exit 0
