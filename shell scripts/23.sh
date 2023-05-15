#!/bin/bash


	find /home/students -type f -printf "%p %T@ \n" 2> /dev/null | sort -nr -k2 | head -1 | awk -F '/' '{print $4,$6}'
