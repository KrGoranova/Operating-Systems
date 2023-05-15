#!/bin/bash

user=$(whoami)

if [[ $# -ne 1 ]] || [[ ! $1 =~ ^[0-9]+$ ]];then
	echo "Argument must be only 1 and digit"
	exit 1
fi

if [[ $user != "oracle" ]] && [[ $user != "grid" ]];then
	echo "You don't have permissions to execute this file"
	exit 2
fi

if [[ -z $ORACLE_HOME ]];then
	echo "There is no environment variable ORACLE_HOME"
	exit 3
fi

if [[ ! -x $ORACLE_HOME/bin/adrci ]];then
	"There is no executable file adrci"
	exit 4
fi

if [[ $1 -lt 2 ]];then
	echo "First argument must be at least 2"
	exit 5
fi

temp=$(mktemp)
minutes=$(echo "$1 * 60" | bc)

$ORACLE_HOME/bin/adrci exec="SET BASE /u01/app/$user; SHOW HOMES" | egrep "^[^/]+/(rdbms|crs|tnslsnr|kfod|asm)/.+" >> $temp

if (cat $temp | egrep -q "No ADR homes are set");then
	echo "$user has no ADR Homes"
	exit 6
else
	
	while read line
	do

		$ORACLE_HOME/bin/adrci exec="SET BASE /u01/app/$user; SET HOMEPATH ${line}; PURGE -AGE $minutes"

	done < <(cat $temp)
fi

exit 0

