#!/bin/bash

source ./functions.sh;

file=$1;
directory=$PWD;


for version in {13..2}
do
	samtools_folder_name="samtools-1."$version; 
	if [[ -d ./$samtools_folder_name && $version!=12 ]]
	then
		# Coding phase
		go_to samtools_folder_name;
		./run_samtools.sh $directory $file;
		go_to $directory;

		# Decoding phase
		go_to samtools-1.15.1;
		cram_file="htslib_1."$version"_"${file%.*}".cram";
		./decode_samtools.sh $directory $cram_file;
		go_to $directory;
	fi
done

echo "";
echo "All runs finish. See the results at ./History.txt";
