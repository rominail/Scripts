#!/bin/bash
# Kill following programs
program=(rambox telegram thunderbird megasync hp-toolbox meteo)
if [ "$1" = 'launch' ]; then
	for i in ${program[@]}
	do
		echo "Launching $i..."
		$i &
	done
else
	for i in ${program[@]}
	do
		echo "Killing $i..."
		if [ -n "`pgrep -o $i`" ]; then
			kill `pgrep -o $i`
			echo "$i killed"
		else
			echo "$i is not running"
		fi
	done
fi

exit 0
