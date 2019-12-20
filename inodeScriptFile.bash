#!/bin/bash

# takes in command line inputs from main.bash: command line format stated in main.bash
inodeSize=$1 
stype=$2
kblock=$3 
byteaddy=$4


echo "                       "
echo "File Size: $inodeSize" 
echo "Size Type: $stype"
echo "Assume $kblock Blocks"
echo "$byteaddy Bytes Address"
echo "                       "

file="./outfile.txt"

if [[ -e $file ]] ; then
	touch $file
fi
	
case $stype in
	bytes|BYTES) 
		newsType=$inodeSize;;
	KB|kb) 
		newsType=$(( $inodeSize * 1024 ));;
	MB|mb) 
		newsType=$(( ( $inodeSize * 1024) * 1024 ));;
	GB|gb) 
		newsType=$(( (( $inodeSize * 1024) * 1024 ) * 1024 ));;
	TB|tb) 
		newsType=$(( ((( $inodeSize * 1024 ) * 1024 )  * 1024) * 1024 ));;
	*)
		echo "ERROR: bad size type"
		exit;;
esac

#initialize vars
dataBlocks=0
directBlocks=0
singleBlocks=0
doubleBlocks=0

divider=$(( (1024 * $kblock) / $byteaddy ))
blockSize=$(( 1024 * $kblock ))

if [[ "$newsType" -le "$blockSize" ]] ; then
	let dataBlocks=1
	echo "$dataBlocks block of data"
	#calculate total blocks needed not including inode
	Total=$(( $dataBlocks + $directBlocks + $singleBlocks + $doubleBlocks ))
	echo "Total Blocks = $Total"
	echo "--------------------------"
	echo "$1: $dataBlocks , $directBlocks , $singleBlocks , $doubleBlocks , $Total " >> "$file"
	exit;
fi

#calculate data blocks
let dataBlocks=$(( $newsType / $blockSize ))


if [[ $dataBlocks -eq 12 ]] && [[ $(( $newsType % $blockSize )) -ne 0 ]] ; then
	echo "$dataBlocks blocks of data"
	let directBlocks=1
	echo "$directBlocks blocks of data"
	#calculate total blocks needed not including inode
	Total=$(( $dataBlocks + $directBlocks + $singleBlocks + $doubleBlocks ))
	echo "Total Blocks = $Total"
	echo "--------------------------"
	exit;
fi

#calculate blocks of direct pointer
if [[ $dataBlocks -ge 12 ]] ; then

	echo "$dataBlocks blocks of data"
	directBlocks=$(( $dataBlocks - 12 ))
	if [[ $(( $directBlocks % $divider )) -ne 0 ]] && [[ $directBlocks -gt $divider ]] ; then
		directBlocks=$(( ($directBlocks / $divider)+1 ))
	elif [[ $(( $directBlocks % $divider )) -eq 0 ]] && [[ $directBlocks -gt $divider ]] ; then
		directBlocks=$(( $directBlocks / $divider ))
	elif [[ $directBlocks -eq 0 ]] ; then
		#calculate total blocks needed not including inode
		Total=$(( $dataBlocks + $directBlocks + $singleBlocks + $doubleBlocks ))
		echo "Total Blocks = $Total"
		echo "--------------------------"
		echo "$1: $dataBlocks , $directBlocks , $singleBlocks , $doubleBlocks , $Total " >> "$file" 
		exit;
	else
		directBlocks=1
	fi
	echo "$directBlocks blocks of direct pointer"
elif [[ $dataBlocks -ge 1 ]] && [[ $dataBlocks -lt 12 ]] ; then
	if [[ $newsType -gt $divider ]] && [[ $(( $newsType % $divider )) -ne 0 ]]  ; then
		dataBlocks=$(( ($newsType / $blockSize ) + 1 ))
	elif [[ $newsType -gt $divider ]] && [[ $(( $newsType % $divider )) -eq 0 ]] ; then
		dataBlocks=$(( ($newsType / $blockSize )))
	else
		dataBlocks=2
	fi
	echo "$dataBlocks blocks of data"
	#calculate total blocks needed not including inode
	Total=$(( $dataBlocks + $directBlocks + $singleBlocks + $doubleBlocks ))
	echo "Total Blocks = $Total"
	echo "--------------------------"
	echo "$1: $dataBlocks , $directBlocks , $singleBlocks , $doubleBlocks , $Total " >> "$file" 
	exit;
fi

#calculate blocks of single indirect pointer
if [[ $directBlocks -ne 0 ]] ; then
	singleBlocks=$(( $directBlocks - 1 ))
	if [[ $(( $singleBlocks % $divider )) -ne 0 ]] && [[ $singleBlocks -gt $divider ]] ; then
		singleBlocks=$(( ($singleBlocks / $divider) + 1 ))
	elif [[ $(( $singleBlocks % $divider )) -eq 0 ]] && [[ $singleBlocks -gt $divider ]] ; then
		singleBlocks=$(( $directBlocks / $divider ))
	elif [[ $directBlocks -eq 1 ]] ; then
		#calculate total blocks needed not including inode
		Total=$(( $dataBlocks + $directBlocks + $singleBlocks + $doubleBlocks ))
		echo "Total Blocks = $Total"
		echo "--------------------------"
		echo "$1: $dataBlocks , $directBlocks , $singleBlocks , $doubleBlocks , $Total " >> "$file" 
		exit;
	else
		singleBlocks=1
	fi
	echo "$singleBlocks blocks of single indirect pointer"
fi
#calculate blocks of double indirect pointer
if [[ $singleBlocks -ne 0 ]] ; then
	doubleBlocks=$(( $singleBlocks - 1 ))
	if [[ $(( $doubleBlocks % $divider )) -ne 0 ]] && [[ $doubleBlocks -gt $divider ]] ; then
		doubleBlocks=$(( ($doubleBlocks / $divider) + 1 ))
	elif [[ $(( $doubleBlocks % $divider )) -eq 0 ]] && [[ $doubleBlocks -gt $divider ]] ; then
		doubleBlocks=$(( $doubleBlocks / $divider ))
	elif [[ $singleBlocks -eq 1 ]] ; then
		#calculate total blocks needed not including inode
		Total=$(( $dataBlocks + $directBlocks + $singleBlocks + $doubleBlocks ))
		echo "Total Blocks = $Total"
		echo "--------------------------"
		echo "$1: $dataBlocks , $directBlocks , $singleBlocks , $doubleBlocks , $Total " >> "$file" 
		exit;
	else
		doubleBlocks=1
	fi
	echo "$doubleBlocks blocks of double indirect pointer"
fi

#calculate total blocks needed not including inode
Total=$(( $dataBlocks + $directBlocks + $singleBlocks + $doubleBlocks ))
echo "Total Blocks = $Total"
echo "--------------------------"

echo "$1: $dataBlocks , $directBlocks , $singleBlocks , $doubleBlocks , $Total " >> "$file" 
