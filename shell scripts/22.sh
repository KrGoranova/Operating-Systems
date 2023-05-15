#!/bin/bash


user_processes=$(ps -u $1 | wc -l)
echo "$user_processes"

while read line
do

echo "$line" | awk -v user=$user_processes '$1 > user {print $2}' 

done< <(ps -eo user= | sort | uniq -c)

avg_time=$(ps -eo time= | sed -E 's/(^[0-9]{2}):([0-9]{2}):([0-9]{2})/\1*3600 + \2*60 +\3/g' | bc | awk '{sum+=$1}END{print sum}')

avg_double=$(echo "$avg_time * $avg_time" | bc)


