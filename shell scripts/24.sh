#!/bin/bash

if [ ! -d $1 ];then 
	echo "First argument is not a directory"
	exit 1
fi

if [ $# -eq 2 ];then
	find $1 -type f -printf "%p %n\n" 2> /dev/null | awk -v hardlink=$2 '$2>=hardlink {print $1}'
else
	find $1 -xtype l 2> /dev/null
fi





