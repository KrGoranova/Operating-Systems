#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "Parameters must be 2"
	exit 1
fi

if [[ ! -d $2 ]];then
	echo "Second argument must be directory"
	exit 2
fi
touch ./$1

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key" >> $1
while read line
do
	
  hostname=$(basename $line | sed 's/\.log//g')
  license=$(cat $line | egrep "license" | sed -E 's/(^.+a[n]?[[:space:]]+)(.+)([[:space:]]+license.$)/\2/g' )
  read phy vlans hosts failover vpn peers vlan SN key < <(cat $line | awk '$1=="Maximum"{phy=$5}
  	$1=="VLANs" {vlans=$3}
  	$1=="Inside" {hosts=$4}
  	$1=="Failover" {failover=$3}
  	$1=="VPN-3DES-AES" {vpn=$3}
  	$1=="*Total" {peers=$5}
  	$1=="VLAN" {vlan=$5}
  	$1=="Serial" {sn=$3}
	$1=="Running" {key=$4; print phy,vlans,hosts,failover,vpn,peers,vlan,sn,key}')
echo "$hostname,$phy,$vlans,$hosts,$failover,$vpn,$peers,$vlan,$license,$SN,$key" >> $1

done < <(find $2 -type f -regextype egrep -regex ".+\.log$" )

