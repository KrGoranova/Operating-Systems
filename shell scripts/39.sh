#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "2 arguments!"
	exit 1
fi

file=$(mktemp)

mkdir -p ./$2/images

while read line
do
	name=$(basename "$line" | sed -E 's/\([^\(\)]+\)//g' | sed 's/\.jpg//g' | tr -s ' ')
	album=$(basename "$line" | sed -E 's/^(.*)(\([^\(\)]+\))([^\(\)]*)(\.jpg$)/\2/g' | sed 's/[\(\)]//g')
	if [[ -z $album ]];then
		album="misc"
	fi

	data=$(stat "$line" -c "%y" | cut -d ' ' -f1)
	hesh=$(sha256sum "$line" | cut -c -16)
	
	touch ./$2/images/$hesh.jpg

	cat "$line" > ./$2/images/$hesh.jpg

	first_sym=$2/by-date/"$data"/by-album/"$album"/by-title
	echo "$first_sym"
	if [[ ! -e "$first_sym" ]];then
		mkdir -p "$first_sym"

	fi 
	ln -s $(realpath $2/images/$hesh.jpg) "$first_sym"/"$name".jpg

	second_sym=$2/by-date/"$data"/by-title
	if [[ ! -e "$second_sym" ]];then
		mkdir -p "$second_sym"
	fi
	ln -s $(realpath $2/images/$hesh.jpg) "$second_sym"/"$name".jpg

	third_sym=$2/by-album/"$album"/by-date/"$data"/by-title
    if [[ ! -e "$third_sym" ]];then
          mkdir -p "$third_sym"
    fi
    ln -s $(realpath $2/images/$hesh.jpg) "$third_sym"/"$name".jpg

	fourth_sym=$2/by-album/"$album"/by-title
    if [[ ! -e "$fourth_sym" ]];then
           mkdir -p "$fourth_sym"
    fi
    ln -s $(realpath $2/images/$hesh.jpg) "$fourth_sym"/"$name".jpg
	
	 fifth_sym=$2/by-title
    if [[ ! -e "$fifth_sym" ]];then
           mkdir -p "$fifth_sym"
    fi
    ln -s $(realpath $2/images/$hesh.jpg) "$fifth_sym"/"$name".jpg
	

done < <(find $1 -type f -regextype egrep -regex ".+\.jpg" )
