#!/bin/bash

if [[ $# -ne 1 ]];then
	echo "Wrong number of arguments"
	exit 1
fi

if [[ -d $1  ]];then
	find $1 -xtype l 
else 
	echo "not directory"
	exit 2
fi

exit 0
