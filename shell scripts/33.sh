#!/bin/bash

file=$(mktemp)

while read line
do
	
	if (echo $line | egrep -q "^-?[0-9]+$");then
		if ! (cat $file | egrep -q "^$line$");then
			echo "$line" >> $file
		fi
	fi
done

max_abs=0
while read line
do
	if (echo $line | egrep -q "-");then
		positive=$(echo "$line * -1" | bc)
		if [[ $positive -gt $max_abs ]];then
			max_abs=$positive
		fi
	else
		if [[ $line -gt $max_abs ]];then
			max_abs=$line
		fi
	fi
done < <(cat $file)

cat $file | egrep "^-?$max_abs"

rm -- $file


