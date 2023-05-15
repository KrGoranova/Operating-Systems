#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "Args must be 2"
	exit 1
fi

if [[ ! -f $1 ]];then
     echo "First argument must be file"
     exit 2
fi

if [[ ! -d $2 ]];then
	echo "Second argument must be directory"
	exit 3
fi

if [[ $(ls $2 | wc -l) -ne 0  ]];then
	echo "Directory must be empty"
	exit 4
fi

number=1
touch $2/dict.txt

while read line
do
	name=$(echo "$line" | sed -E 's/^([[:alpha:][:space:]-]*)([\(:]+)(.+)$/\1/g' | awk '{print $1,$2}')


	if ! (cat $2/dict.txt | egrep -q "$name");then
		echo "$name;$number" >> $2/dict.txt

		touch $2/$number 
		cat $1 | egrep "$name" >> $2/$number
		
		number=$(echo "$number + 1" | bc)
		echo "$number"
	fi



done < <(cat $1)
