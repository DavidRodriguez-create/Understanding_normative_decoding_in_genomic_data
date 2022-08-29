#!/bin/bash

# $1 functions.sh path
# $2 full path fastq file 1
# $3 s (single), p (pair-end) 
# $4 action: c (encode), b (both encode and decode)
# $5 yes/no delete spring file after used

source $1/functions.sh

scalce_generic_encoder(){

	fastq_file=$1
	input_type=$2
	result=$3

	if [ $input_file == "p" ]
	then

		echo "";
        	echo "Starting encoding FASTQ -> SCALCE ( $(basename $fastq_file) & $(basename $fastq_file_2) -> $(basename $result).* )"
	        echo ""

		$scalce_path/scalce $fastq_file -r -o $result
	else

		echo "";
                echo "Starting decoding FASTQ -> SCALCE ( $(basename $fastq_file) -> $(basename $result).scalce* )";
		echo ""

		$scalce_path/scalce $fastq_file -o $result
	fi

	register "scalce" $result+".scalcen.gz"
	register "scalce" $result+".scalcer.gz"
	register "scalce" $result+".scalceq.gz"

}

scalce_generic_decoder(){

	fastq_file=$1
        input_type=$2
        result=$3

	if [ $input_file == "p" ]
	then

		echo "";
	        echo "Starting decoding SCALCE -> FASTQ ( $(basename $result) -> $(basename $fastq_file) & $(basename $fastq_file _2) )";
		echo ""

		$spring_path/scalce $result+".scalcen.gz" -d -i $spring_file -o $fastq_file $fastq_file_2
		register "spring" $fastq_file+"_2"
	else

		echo "";
	        echo "Starting decoding SCALCE -> FASTQ ( $(basename $result) -> $(basename $fastq_file) )";
		echo ""

		$spring_path/spring -d -i $spring_file -o $fastq_file
	fi

	register "scalce" $fastq_file;

}

used_file=$2
input_type=$3
action=$4;
delete_after_end=$5

fastq_file=${used_file%.*}".fastq"
result=${used_file%.*}"

new_fastq_file=${used_file%.*}"_decoded.fastq"

extension_used_file=${used_file##*.}

case $extension_used_file in

	"fastq" | "fq")

		if [ $action == "c" ]
                then
                        scalce_generic_encoder $fastq_file $input_type $result
                elif [ $action == "b" ]
		then
#                        spring_generic_encoder $fastq_file $fastq_file_2 $spring_file
#			spring_generic_decoder $fastq_file $fastq_file_2 $spring_file $delete_after_end

                fi

	;;
	"scalce"*)

#		spring_generic_decoder $fastq_file $fastq_file_2 $spring_file $delete_after_end

	;;
	*)

                echo"";
                echo "Incorrect format"

        ;;
esac
