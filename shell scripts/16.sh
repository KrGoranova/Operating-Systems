#!/bin/bash

if [[ $(whoami) != "s62385" ]]; then
	echo "Not root"
	exit 1
fi

if [[ $# -ne 1 ]];then
	echo "Wrong number of arguments"
	exit 2
fi


while read line
do
	pid=$(ps -u $line -o  pid= | sort -nr -k1 | head -1 )
	total_rss=$(ps -u $line -o rss= | awk 'BEGIN{total=0}{total+=$1}END{print total}')
	count_processes=$(ps -u $line | wc -l)

	echo "user: $line total rss: $total_rss"

	if [[ $total_rss -gt $1 ]];then
		#kill $pid
		echo "kill $pid "
	fi

	

done < <(ps -eo user= | sort | uniq )



exit 0
