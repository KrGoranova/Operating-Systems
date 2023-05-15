#!/bin/bash

if [[ -z $ORACLE_HOME ]] || [[ -z $ORACLE_BASE ]] || [[ -z $ORACLE_SID ]];then
	echo "Three environment variables are needed"
	exit 1
fi

user=$(whoami)
if [[ $user != "oracle" ]] && [[ $user != "grid" ]];then
	echo "You have no permissions to execute this file"
	exit 2
fi

if [[ $# -ne 1 ]] || [[ $1 =~ ^[0-9]+$ ]];then
	echo "Not valid argument"
	exit 3 
fi

if [[ $user == "oracle" ]];then
	role="sysdba"
else 
	role="sysasm"
fi

name_host=$(hostname -s)
diag_dest=$($ORACLE_HOME/bin/sqlplus SL "/ as $role" @a.sql | awk 'NR==4 {print $0}')

if [[ ! -z $diag_dest ]];then
	diag_base=$diag_dest
else
	diag_base=$ORACLE_HOME
fi

if [[ $user == "oracle" ]];then

	rdbms=$(find $diag_base/diag/rdbms -maxdepth 2 -mindepth 2 -type f -regextype egrep -regex "^.+_[0-9]+\.(trc|trm)$" -mtime +"$1" -printf "%s\n" | awk '{sum+=$1}END{print sum}')

	rdbms=$(echo "$rdbms / 1024" | bc)

	echo "rdbms: $rdbms"

elif [[ $user == "grid" ]];then
	crs=$(find $diag_base/diag/crs/name_host/crs/trace -type f -regextype egrep -regex "^.+_[0-9]+\.(trc|trm)$" -mtime +"$1" -printf "%s\n" | awk '{sum+=$1}END{print sum}')
    
	crs=$(echo "$crs / 1024" | bc)
	echo "crs: $crs"
	
	tnslsnr=...


