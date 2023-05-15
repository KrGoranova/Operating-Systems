#!/bin/bash

if [[ $# -ne 2 ]];then 
	echo "Arguments must bbe 2"
	exit 1
fi

if [[ ! -f $1 ]] || [[ ! -f $2 ]];then
	echo "Arguments must be files"
	exit 2
fi
size=$(stat -c "%s" $1)

if [[ $(echo "$size % 2" | bc) -ne 0 ]];then
	echo "File is not binary"
	exit 3
fi

echo -e "#include <stdio.h>\n" >> $2

arrN=$(echo "$size /2" | bc)

if [[ $arrN -gt 524288 ]];then
	echo "File is not valid"
	exit 4
fi

echo "const uint32_t arrN = $arrN;" >> $2

echo "const uint16_t arr [] = {" >> $2

for num in $(xxd $1 | cut -c 10-49)
do
	num=$(echo "$num" | sed -E "s/^([0-9]{2})([0-9]{2})$/\2\1/g")

	new="0x$num"

	echo "$new, " >> $2
done

sed -i -E "s/(^.+),([^,]+)$/\1\2/g" $2


echo -n " }" >> $2
