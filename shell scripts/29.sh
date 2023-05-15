#!/bin/bash


rss_root=$(ps -u "root" -o rss= | awk '{total+=$1}END{print total}')
while read line
do
	dir=$(echo "$line" | awk '{print $2}')
	user=$(echo "$line" | awk '{print $1}')
	if [[ -e $dir ]];then
		perm=$(stat -c '%a' $dir | cut -c 1)
	fi

	if [[ ! -e $dir ]] || [[ $(stat -c "%U" $dir) != $user ]] || [[ ! ($perm -eq 7 || $perm -eq 6 || $perm -eq 2 || $perm -eq 3) ]];then

		rss_user=$(ps -u $user -o rss | awk '{total+=$1}END{print total}')
		if [[ $rss_user -gt $rss_root]];then
	#	ps -u "$user" -o pid | xargs -I {} kill -15 {};
                echo "kill -15 pid";
		fi
	fi

done < <(cat /etc/passwd | egrep -v "root" | cut -d ':' -f1,6 | tr -s ':' ' ')
