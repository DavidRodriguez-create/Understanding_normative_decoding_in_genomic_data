#!/bin/bash

# $1 functions.sh path
# $2 full path fastq file 1
# $3 full path fastq file 2 , else "-"
# $4 action: c (encode), b (both encode and decode)
# $5 yes/no delete spring file after used

source $1/functions.sh

spring_generic_encoder(){

	fastq_file=$1
	fastq_file_2=$2
	spring_file=$3

	if [ ${fastq_file_2##*.} == "fastq" ] ||  [ ${fastq_file_2##*.} == "fq" ]
	then

		echo "";
        	echo "Starting encoding FASTQ -> SPRING ( $(basename $fastq_file) & $(basename $fastq_file_2) -> $(basename $spring_file))";
	        echo ""

		$spring_path/spring -c -i $fastq_file $fastq_file_2 -o $spring_file
	else

		echo "";
                echo "Starting decoding FASTQ -> SPRING ( $(basename $fastq_file) -> $(basename $spring_file) )";
		echo ""

		$spring_path/spring -c -i $fastq_file -o $spring_file
	fi

	register "spring" $spring_file

}

spring_generic_decoder(){

	fastq_file=$1
	fastq_file_2=$2
	spring_file=$3

	if [ ${fastq_file_2##*.} == "fastq" ] ||  [ ${fastq_file_2##*.} == "fq" ]
	then

		echo "";
	        echo "Starting decoding SPRING -> FASTQ ( $(basename $spring_file) -> $(basename $fastq_file) & $(basename $fastq_file_2) )";
		echo ""

		$spring_path/spring -d -i $spring_file -o $fastq_file $fastq_file_2
		register "spring" $fastq_file_2
	else

		echo "";
	        echo "Starting decoding SPRING -> FASTQ ( $(basename $spring_file) -> $(basename $fastq_file) )";
		echo ""

		$spring_path/spring -d -i $spring_file -o $fastq_file
	fi

	register "spring" $fastq_file;

}

used_file=$2
used_file_2=$3
action=$4;
delete_after_end=$5

fastq_file=$used_file
fastq_file_2=$used_file_2
spring_file=${used_file%.*}".spring"

new_fastq_file=${used_file%.*}"_decoded.fastq"
new_fastq_file_2=${used_file_2%.*}"_decoded.fastq"

extension_used_file=${used_file##*.}

echo $used_file
echo $used_file_2
echo $action
echo $delete_after_end

echo $fastq_file
echo $fastq_file_2
echo $spring_file

echo $new_fastq_file
echo $new_fastq_file_2

echo $extension_used_file
echo ""

case $extension_used_file in

	"fastq" | "fq")

		if [ $action == "c" ]
                then
                        spring_generic_encoder $fastq_file $fastq_file_2 $spring_file
                elif [ $action == "b" ]
		then
                        spring_generic_encoder $fastq_file $fastq_file_2 $spring_file
			spring_generic_decoder $fastq_file $fastq_file_2 $spring_file $delete_after_end

                fi

	;;
	"spring")

		spring_generic_decoder $fastq_file $fastq_file_2 $spring_file $delete_after_end

	;;
	*)

                echo"";
                echo "Incorrect format"

        ;;
esac
