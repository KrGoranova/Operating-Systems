#!/bin/bash

if [[ $# -ne 3 ]];then
	echo "Arguments must be 3"
	exit 1
fi

if [[ ! -f $1 ]] || [[ ! -f $2 ]] || [[ ! -d $3 ]];then
	echo "First two arguments must be files and third - dir"
	exit 2
fi

temp=$(mktemp)


while read file
do
	
	username=$(basename $file | sed 's/\.cfg//g')

	while read line
	do
		number_line=$(echo $line | awk '{print $1}')
		data_line=$(echo $line | sed -E 's/(^[[:space:]]*[[:digit:]]+[[:space:]]*)(.*$)/\2/g') 
		
		if (echo $data_line | egrep -v -q "(^$|^{.+};$|^{.+; };|^# .*$)") ;then
			if ! (cat $temp | egrep -q "Error in $(basename $file):");then
				echo "Error in $(basename $file):"
				echo "Error in $(basename $file):" >> $temp
			fi
			echo "Line $number_line:$data_line"
		fi
	
	done < <(cat -n $file)

	if ! (cat $temp | egrep -q "Error in $(basename $file):"); then
		
		cat $file >> $2

		if ! (cat $1 | egrep -q "^$username");then
			passwd=$(pwgen 16 1)

			echo "$username $passwd"
			echo "$username:$passwd" >> $1
		fi
	fi

done < <(find $3 -type f -regextype egrep -regex ".+\.cfg")
