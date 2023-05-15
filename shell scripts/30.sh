#!/bin/bash

friends=$(mktemp)

while read line
do
	
	friend=$(dirname $line | sed -E 's/(.+)\/([^\/]+$)/\2/g')
	
	num_lines=$(cat $line | wc -l)
	if (cat $friends | egrep -q "$friend");then
		
		old_num_lines=$(cat $friends | egrep "$friend" | awk '{print $2}')
		total_lines=$(echo "$num_lines + $old_num_lines" | bc)

		sed -E -i "s/^$friend $old_num_lines$/$friend $total_lines/g" $friends
		
	else
		echo "$friend $num_lines" >> $friends
	fi
	
done < <(find $1 -type f | egrep "[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}\.txt$" )
	
	cat $friends | sort -nr -k2 

	rm --$friends
