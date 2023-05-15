#!/bin/bash

if [[ $(whoami) != "root" ]];then
	echo "You are not root"
	exit 1
fi


while read line
do
	rss=$(ps -u "$line" -o rss= | awk '{all+=$1}END{print all}')
	double_rss=$(echo "$rss * 2" | bc)
	echo "user $line number of processes $(ps -u $line | wc -l) total_rss $rss"
	max_rss_pid=$(ps -u $line -o rss=,pid= | sort -nr -k1 | head -1)
	max_rss=$(echo "$max_rss_pid" | awk '{print $1}')
	max_pid=$(echo "$max_rss_pid" | awk '{print $2}')

	read max_rss max_pid < $(ps -u $line -o rss=,pid= | sort -nr -k1 | head -1)

	if [[ $max_rss -eq $double_rss ]];then
		kill -s SIGTERM $max_pid
		sleep 2
		kill -s SIGKILL $max_pid
	fi

done < <(ps -e -o user= | sort | uniq)

exit 0;
