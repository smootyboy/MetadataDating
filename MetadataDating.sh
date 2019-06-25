#!/bin/bash

if [[ "$#" -ne 3 && "$#" -ne 2 ]]; then
	echo "Illegal number of parameters"
	exit 1
fi

if [[ ! -d $1 ]]
then
	echo "Please give a valid directory"
	exit 1
fi

if [[ -d $2 ]]
then
	while true; do
		read -p "Output directory already exists. This could overwrite the contents. Do you wish to proceed?[y/n]`echo $'\n> '` " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) echo "Aborted" ;exit 1;;
			* ) echo "Please answer Y or N.";;
		esac
	done
fi

resultDir=$2
mkdir -p "$resultDir"

datasetDir="$(cd "$1" && pwd -P)"

find "$datasetDir" -mindepth 0 -maxdepth 0 -type d  -printf "%p\t%A+\t%T+\t%C+\t%A@\t%T@\t%C@\n" >| "${resultDir}/MACTimes.tsv"
find "$datasetDir" -mindepth 1 -maxdepth 1 -type d >| "${resultDir}/dirsToCheck.txt"

while [ -s "${resultDir}/dirsToCheck.txt" ];
do
	sh MACTimeDirs.sh $resultDir
done

find "$datasetDir" -type f -printf "%p\t%A+\t%T+\t%C+\t%A@\t%T@\t%C@\n" >> "${resultDir}/MACTimes.tsv"

cut -f1 "${resultDir}/MACTimes.tsv" | xargs -d "\n" stat --printf "%w\n" >| "${resultDir}/BirthTimes.tsv"

paste -d"\t" "${resultDir}/MACTimes.tsv" "${resultDir}/BirthTimes.tsv" >| "${resultDir}/MACBTimes.tsv"

cut -f1 "${resultDir}/MACTimes.tsv" |sed 's|.*/||'| awk -F. '{print (NF>1?$NF:"")}' >| "${resultDir}/extensions.tsv"

echo -e "File\tAccess Time\tModify Time\tChange Time\tAccess Time(epoch)\tModify Time(epoch)\tChange Time(epoch)\tBirth Time\tExtension" >| "${resultDir}/results.tsv"
paste -d"\t" "${resultDir}/MACBTimes.tsv" "${resultDir}/extensions.tsv" >> "${resultDir}/results.tsv"

if [ ! -z "$3" ]
then
	awk -F"\t" 'FNR==NR{k[$1]=1;next;} FNR==1 || k[$9]' "${3}" "${resultDir}/results.tsv" >| "${resultDir}/subsetResults.tsv"
fi



