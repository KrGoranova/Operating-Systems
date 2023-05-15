#!/bin/bash

if (cat "proc_acpi" | egrep -q "^$1[[:space:]]+.+");then
	stat=$(cat "proc_acpi" | egrep "^$1[[:space:]]+.+" | awk '{print $3}')

	if [[ $stat == "*enabled" ]];then
		echo "$1" >> "proc_acpi"
	fi
fi
