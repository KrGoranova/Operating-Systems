#!/bin/bash

if [[ $# -ne 1 ]];then
	echo "Argument must be only 1"
	exit 1
fi

if [[ ! -f $1 ]];then
	echo "Parameter must be file"
	exit 2
fi

while read line
do
	http20=$(cat $1 | egrep "$line" | egrep "HTTP/2\.0" | wc -l)
	http1011=$(cat $1 | egrep "$line" | egrep -v "HTTP/2\.0" | wc -l)

	echo "$line HTTP/2.0: $http20 non-HTTP/2.0: $http1011"

done < <(cat $1 | cut -d " " -f2 | sort | uniq -c | sort -nr -k1 | head -3 | awk '{print $2}')

cat $1 | awk '$9 > 302 {print $0}' | cut -d ' ' -f1 | sort | uniq -c | sort -nr -k1 | head -5

exit 0
