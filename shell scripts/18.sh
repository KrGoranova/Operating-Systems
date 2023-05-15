#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "Wrong number of arguments"
	exit 1
fi

if  ! (echo "$1" | egrep -q "^[0-9]+$" && echo "$2" | egrep -q "^[0-9]+$");then
	echo "Args must be digits"
	exit 2
fi

mkdir ./a
#mkdir ./b
#mkdir ./c

while read line
do
	if [[ $(cat $line | wc -l) -lt $1 ]];then
		mv ./$line ./a/$line
	elif
		[[ $(cat $line | wc -l) -lt $2]] && [[ $(cat $line | wc -l) -gt $1 ]];then
		mv ./$line ./b/$line
	else
		mv ./$line ./c/$line
	fi
done < <(find . -maxdepth 1 -type f)
