#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "Wrong number of arguments"
	exit 1
fi

if [[ ! -f $1 ]] || [[ ! -f $2 ]];then
	echo "Args must be files"
	exit 2
fi

lines1=$(cat $1 | egrep "$1" | wc -l)
lines2=$(cat $2 | egrep "$2" | wc -l)

tempFile=$(mktemp)

if [[ $lines1 -gt $lines2 ]];then
	cat $1 >> $tempFile
	name=$(echo $1)
else
	cat $2 >> $tempFile
	name=$(echo $2)
fi

cat $tempFile | sed -E 's/([^"]+)"(.+)/"\2/g' | sort -d >> ./"$name.songs"

rm -- $tempFile

exit 0
