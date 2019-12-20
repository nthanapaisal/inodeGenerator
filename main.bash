#!/bin/bash

#commandline input: bash main.bash input.txt
#input.txt format[ex]: 111 GB 4 4 

file=$1


while read -r line; do

	bash inodeScriptFile.bash $line
	
	#echo ">>$line"

done < "$file"
