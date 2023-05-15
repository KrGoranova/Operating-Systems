#!/bin/bash

if [[ $(whoami) != "s62385" ]];then
	echo "Not root"
	exit 1
fi

while read line
do
	user=$(echo $line | cut -d ':' -f1)
	homedir=$(echo $line | cut -d ':' -f2)

 	if [[ -d $homedir ]];then
		perm=$(stat -c '%a' $homedir | cut -c 1)
		echo "$perm"
		if [[ ! ($perm -eq 7 || $perm -eq 6 || $perm -eq 2 || $perm -eq 3) ]];then
			echo "$user does not have write permission"
		fi
	fi


	 if [[ ! -d $homedir ]];then
		echo "$user does not have home directory"
	fi






done < <(cat /etc/passwd | cut -d ':' -f1,6)

exit 0
