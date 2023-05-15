#!/bin/bash

while read line
do
name=$(echo $line | awk '{print $1}')
setting=$(echo $line | awk '{print $2}')

if (echo "$name" | egrep -q "^[A-Z0-9]{0,4}$");then
	if !(cat /proc/acpi/wakeup | egrep -q "^$name[[:space:]]+.+$");then
		echo "There is no such name"
	else
		orig_set=$(cat /proc/acpi/wakeup | egrep "^$name[[:space:]]+.+$" | awk '{print $3}')
		if [[ $orig_set != $setting ]];then
		echo $name >> /proc/acpi/wakeup
		fi
	fi

fi


done < <(cat $1 | egrep -v "^#.+$")
