#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "Arguments must be 2"
	exit 1
fi

if [[ ! -f $1 ]] || [[ ! -f $2 ]];then
	echo "Arguments must be files"
	exit 2
fi

while read line
do
	fields=$(echo "$line" | cut -d ',' -f2,3,4)
	if [[ $(cat $1 | cut -d ',' -f2,3,4 | egrep "$fields" | wc -l) -eq 1 ]];then
		echo $line >> $2
	else
		row=$(cat $1 | egrep "^.+,$fields$" | sort -n -t ',' -k1 | head -1)
		if ! (cat $2 | egrep -q "$row");then
			echo "$row" >> $2
		fi
	fi

done < <(cat $1)
