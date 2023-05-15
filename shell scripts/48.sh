#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "Arguments must be 2"
	exit 1
fi

if [[ ! -d $1 ]] || [[ ! -d $2 ]];then
	echo "Arguments must be directories"
	exit 2
fi

if [[ $(find $2 -maxdepth 0 -empty | wc -l) -ne 1 ]];then
	echo "Second directory must be empty"
	exit 3
fi

first_dir=$(basename $1)
while read line
do
	directory=$(dirname $line)
	filename=$(basename $line)
	
	new_dir=$(echo $directory | sed -E "s/(^.*$first_dir\/?)(.*$)/\2/g")
	if [[ ! -z $new_dir ]] && [[ ! -e $2/$new_dir ]];then
		mkdir -p $2/$new_dir
	fi
	

	if (echo $filename | egrep -q "^\..+\.swp$");then
		name=$(echo $filename | sed -E 's/(\.)(.+)(\.swp$)/\2/g')

		if ! (find $directory -maxdepth 1 -type f -printf "%f\n" | egrep -q "^$name$");then
			cp $line $2/$new_dir
		fi
	else
		
		cp $line $2/$new_dir

	fi


done < <(find $1 -type f)
