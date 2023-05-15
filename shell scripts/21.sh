#!/bin/bash

if [[ $# -ne 3 ]];then
	echo "Wrong number of args"
	exit 1
fi


if (cat $1 | egrep -q "$3");then

	tempFile=$(mktemp)
	
	string1="$2"
	string2="$3"
	# vuv -v si definirash 1viq i 2riq podaden argument na scripta a veche awk sus $2 ti vzima vtorata kolona ot teksta aaaaa razbrah te, a tam deto e == f1 ili == $f1 trq da e
	# shte razpoznae f1 nqma nujda v awk ot dolar zashtoot tova si e definirana veche pormenliva za samiq awk a ne shell scripta
	# qsno, da se otsvurzvam znavhi, tva kak stavashe
	# purvo da vidq kak go testvash i dali raboti i togava 
	#pishi sega ne izkarva otgore tva deto iskam, emek a b c stana, prosto trqbvashe za vtorata promenliva na scripta
	terms1=$(cat $1 | awk -F '=' -v f1="${2}" '$1 == f1 {print $2}')
	terms2=$(cat $1 | awk -F '=' -v f1="${3}" '$1 == f1 {print $2}')

	while read line
	do
		if ! (echo "$line" | egrep -q "$3");then
			echo "$line" >> $tempFile
		else
			echo -n "$3=" >> $tempFile
			
			for char in $terms2;do
					if ! (echo "$terms1" | egrep -q "$char");then
						echo -n "$char " >> $tempFile
					fi
				done
				echo >> $tempFile
		fi
	done < <(cat $1)
	cat $tempFile
fi

exit 0

