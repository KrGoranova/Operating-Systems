#!/bin/bash

if [[ ! -f $1 ]];then
	echo "Not file"
	exit 1
fi

#cat books | tr -s ' ' | cut -d ' ' -f4- | awk '{cnt+=1}{print cnt". "$0}'
cat $1 | tr -s ' ' | cut -d ' ' -f4- | awk '{print NR".",$0}' | sort -t ' ' -k2
exit 0
