#!/bin/bash

for file in $@
do
	if [[ ! -f $file ]];then
		echo "$file is not a file"
		continue
	fi

	if [[ $(cat $file | egrep "^.+[[:space:]]+SOA[[:space:]]+.+" | wc -l) -ne 1 ]] || !(cat $file | head -1 | egrep -q "^.+[[:space:]]+SOA[[:space:]]+.+");then
		echo "File must have only 1 SOA record and it must be the first one"
		continue
	fi

	if (cat $file | head -1 | egrep -q "\(");then
		serial=$(cat $file | head -2 | tail -1 | awk '{print $1}')
		date=$(echo $serial | cut -c -8)
		today=$(date +"%Y%m%d")
		if [[ $date -lt $today ]];then
			serial="${today}00"
		elif [[ $date -eq $today ]];then
			check=$(echo $serial | cut -c 9-10)
			if [[ $check -eq 99 ]];then
				echo "Last two digits..."
				continue
			else
				serial=$(echo "$serial +1" | bc)
			fi
		fi
		
		sed -i -E "s/^([[:space:]]*)[0-9]{10}([[:space:]]+;[[:space:]]+serial[[:space:]]*)/\1${serial}\2/g" $file
	else
		TTl=$(cat $file | head -1 | awk '{print $2}')
		if [[ $TTL == "IN" ]];then
			serial=$(cat $file | head -1 | awk '{print $6}')
		else serial=$(cat $file | head -1 | awk '{print $7}')
		fi
		date=$(echo $serial | cut -c -8)
        today=$(date +"%Y%m%d")
        if [[ $date -lt $today ]];then
             serial="${today}00"
        elif [[ $date -eq $today ]];then
             check=$(echo $serial | cut -c 9-10)
             if [[ $check -eq 99 ]];then
                 echo "Last two digits..."
                 continue
            else
                 serial=$(echo "$serial +1" | bc)
             fi
		fi
		sed -i -E "s/^(.+)([0-9]{10})([[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]*)$/\1$serial\3/g" $file
	
		fi
	done
exit 0

