#!/bin/bash

resultDir=$1

while read line; do
	find $line -mindepth 0 -maxdepth 0 -type d -printf "%p\t%A+\t%T+\t%C+\t%A@\t%T@\t%C@\n"  >> "${resultDir}/MACTimes.tsv"
	find $line -mindepth 1 -maxdepth 1 -type d  > "${resultDir}/tmp.txt"
done < "${resultDir}/dirsToCheck.txt"

mv "${resultDir}/tmp.txt"  "${resultDir}/dirsToCheck.txt"
