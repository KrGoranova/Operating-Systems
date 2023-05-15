#!/bin/bash

#if [[ $(whoami) != "root" ]];then
#	echo "You do not have permission"
#	exit 1
#fi

while read line
do
	dir=$(echo "$line" | sed -E 's/(^[^\/]+\/)(.+)/\2/g' | sed -E 's/(.+)\/([^\/]+$)/\1/g')
	file=$(echo "$line" | sed -E 's/(^[^\/]+)(.+)/\2/g')
	
	if [ -d $(echo "$1/$dir") ];then
	mkdir -p $2/$dir
	fi
	mv  $line $2$file

done < <(find $1 -type f 2>/dev/null | egrep "$3" )
