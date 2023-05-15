#!/bin/bash


stdout=$(mktemp)

if [[ $1 =~ ^-n$ ]];then
	N=$2
else 
	N=10
fi

for file in "$@"
do
	if [[ -f $file ]];then
		IDF=$(basename $file | sed 's/\.log//g' )
		cat $file | tail -$N | sed -E "s/(^[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]]+[0-9]{2}:[0-9]{2}:[0-9]{2})(.+)/\1 $IDF\2/g" >> $stdout
	fi
done 

cat $stdout | sort -n -t ' ' -k1,2

rm -- $stdout

exit 0
