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

abs_path="$(cd "$1" && pwd -P)"

find $abs_path -printf "%p\t%A+\t%T+\t%C+\t%A@\t%T@\t%C@\n" > "${resultDir}/MACTimes.tsv"

cut -f1 "${resultDir}/MACTimes.tsv" | xargs -d "\n" stat --printf "%w\n" > "${resultDir}/BirthTimes.tsv"

paste -d"\t" "${resultDir}/MACTimes.tsv" "${resultDir}/BirthTimes.tsv" > "${resultDir}/MACBTimes.tsv"

cut -f1 "${resultDir}/MACTimes.tsv" |sed 's|.*/||'| awk -F. '{print (NF>1?$NF:"")}' > "${resultDir}/extensions.tsv"

echo -e "File\tAccess Time\tModify Time\tChange Time\tAccess Time(epoch)\tModify Time(epoch)\tChange Time(epoch)\tBirth Time\tExtension" > "${resultDir}/results.tsv"

paste -d"\t" "${resultDir}/MACBTimes.tsv" "${resultDir}/extensions.tsv" >> "${resultDir}/results.tsv"

#echo -e "File\tATime\tMTime\tCtime\tATime(epoch)\tMtime(epoch)\tCtime(epoch)\tBirth Time\tExtension" > CodeResults.tsv

#awk -F"\t" 'tolower($9) == "sh" || tolower($9) == "c" || tolower($9) == "cgi" || tolower($9) == "o" || tolower($9) == "html" || tolower($9) == "htm" || tolower($9) == "make"' results.tsv >> CodeResults.tsv


if [ ! -z "$3" ]
then
	awk -F"\t" 'FNR==NR{k[$1]=1;next;} FNR==1 || k[$9]' "${3}" "${resultDir}/results.tsv" > "${resultDir}/subsetResults.tsv"
fi



