#!/bin/bash

if [[ $# -ne 3 ]];then
	echo "Arguments must be 3"
	exit 1
fi

if [[ ! -f $1 ]];then
	echo "First argument must be file"
	exit 2
fi

if ! (echo $2 | egrep -q "^[[:alnum:]_]+$");then
	echo "Second argument must be string"
	exit 3
fi

if ! (echo $3 | egrep -q "^[[:alnum:]_]+$");then
    echo "Third argument must be string"
    exit 4
fi


user=$(whoami)
date=$(date)

if (cat $1 | egrep -q "^[[:space:]]*$2[[:space:]]*=[[:space:]]*[^($3)]") && ! (cat $1 | egrep -q "^[[:space:]]*$2[[:space:]]*=[[:space:]]*$3");then
	
	sed -E -i "s/(^[[:space:]]*$2[[:space:]]*=[[:space:]]*[^($3)].*$)/# \1 # edited at $date by $user\n$2 = $3 # added at $date by $user/g" $1

elif ! (cat $1 | egrep -q "^[[:space:]#]*$2");then
	echo "$2 = $3 # added at $date by $user" >> $1
fi

	
