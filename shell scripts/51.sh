#!/bin/bash

while read line
do
user=$(basename $line .cfg)


if [[ $($1/validate.sh $line | wc -l) -ne 0 ]];then
	$1/validate.sh $line | awk -v name=$line '{print name":"$0}' >&2
elif 
	$1/validate.sh $line

	if [[ $? -eq 0 ]];then
		if ! (cat $1/"foo.pwd" | egrep -q "^$user:.+$");then
		pswd=$(pwgen 10 1)
		hesh=$(mkpasswd $pswd)

		echo "$user:$hesh" >> $1/"foo.pwd"
		echo "$user:$pswd"

		cat $line >> $1/foo.conf
		fi
	fi
fi
	
	
done < <(find $1/cfg -type f -regextype egrep -regex "^.+\.cfg$")

