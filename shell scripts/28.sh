#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "Args must be 2"
	exit 1
fi

if [[ ! -d $1 ]];then
	echo "First sargument must be directory"
	exit 2
fi

find $1 -maxdepth 1 -type f | sed -E 's/(.+)\/([^\/]+$)/\2/g' | egrep "^(vmlinuz)-[0-9]+\.[0-9]+\.[0-9]+-$2$" | sort -nr -t '-' -k2 | head -1
