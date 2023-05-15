#!/bin/bash

if [[ $# -ne 3 ]];then
	echo "Arguments must be 3"
	exit 1
fi

if [[ ! $1 =~ ^[0-9]+.?[0-9]*$ ]];then
	echo "First argument is not a number"
	exit 2
fi

decimal=$(cat "prefix.csv" | egrep ".+,$2,.+" | cut -d ',' -f3)
unit_name=$(cat "base.csv" | egrep ".+,$3,.+" | cut -d ',' -f1)
measure=$(cat "base.csv" | egrep ".+,$3,.+" | cut -d ',' -f3)

number=$(echo "$1 * $decimal" | bc)

echo "$number $3 ($measure, $unit_name)"

exit 0
