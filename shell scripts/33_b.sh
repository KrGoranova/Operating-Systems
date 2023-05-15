#!/bin/bash

file=$(mktemp)

 while read line
 do

     if echo $line | egrep -q "^-?[0-9]+$" ;then
         if ! (cat $file | egrep -q "^$line");then
			 
			 number=$(echo $line | sed 's/-//g')
			 sum=0
			
			 while read digit
			 do
				 sum=$(echo "$sum + $digit" | bc)

			 done < <(echo $number | egrep -o .)
				
			 echo "$line $sum" >> $file 
         fi
	 fi
done

cat $file | sort  -k2nr -k1n | head -1 | cut -d ' ' -f1

rm -- $file

exit 0

