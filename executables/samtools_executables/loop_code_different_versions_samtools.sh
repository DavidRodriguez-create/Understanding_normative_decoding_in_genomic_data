#!/bin/bash

source $1/functions.sh;

sam_file=$2
fasta_file=$3
last_version=${samtools_versions[0]}

for version in ${samtools_versions[@]}
do
	samtools_folder_name="samtools-"$version;
	if [[ -d ./versions_samtools/$samtools_folder_name ]]
	then

		# Coding phase
		echo "";
		echo "Coding using $samtools_folder_name ";
		./generic_samtools.sh $origin $sam_file $fasta_file c no - $version $last_version

		# Decoding phase
		echo "";
		echo "Decoding using samtools-"$last_version;
		./generic_samtools.sh $origin ${sam_file%.*}".cram" $fasta_file b yes $version $last_version
	fi
done

echo "";
echo "All runs finished. See the results at "+$1/.. +"/History.txt";

