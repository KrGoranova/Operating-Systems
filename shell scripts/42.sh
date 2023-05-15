#!/bin/bash


user=$(whoami)

if [[ $user != "oracle" ]] && [[ $user != "grid" ]];then
	echo "You don't have permissions"
	exit 1
fi

temp=$(mktemp)

if [[ ! -z $ORACLE_HOME ]];then
	if [[ -x $ORACLE_HOME/bin/adrci ]];then
		
		if [[ $($ORACLE_HOME/bin/adrci exec="show homes" | wc -l) -gt 1 ]];then
			
				$ORACLE_HOME/bin/adrci exec="show homes" >> $temp

				while read line 
				do
					path=$(/u01/app/$user/$line)
					size=$(echo "$(stat $path -c "%s") / 1048576" | bc)

					echo "$size $path"
				done < <(cat $temp | tail -n +2)
		else
			echo "No ADR homes are set"
		fi
	fi
fi


rm -- $temp

exit 0

