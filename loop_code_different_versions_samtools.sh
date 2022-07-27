#!/bin/bash

source ./functions.sh;

file=$1;
directory=$PWD;

if [ -f "$file" ] 
then

for version in {14..2}
do
	samtools_folder_name="samtools-1."$version;
	if [[ -d ./versions_samtools/$samtools_folder_name ]]
	then

		# Coding phase
		echo "";
		echo "Coding using $samtools_folder_name ";
		go_to samtools_folder_name;
		./run_samtools.sh $directory $file;
		go_to $directory;

		# Decoding phase
		echo "";
		echo "Decoding using samtools-1.15.1";
		go_to samtools-1.15.1;
		cram_file="htslib_1."$version"_"${file%.*}".cram";
		./decode_samtools.sh $directory $cram_file;
		go_to $directory;
	fi
done

echo "";
echo "All runs finished. See the results at ./History.txt";
else
	echo "No file found on current directory. If so use the command mv to get it to this directory: $directory";
fi
