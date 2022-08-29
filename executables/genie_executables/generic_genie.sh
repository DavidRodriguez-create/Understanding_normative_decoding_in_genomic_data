#!/bin/bash

# $1 functions.sh path
# $2 full path file used for compression
# $3 full path file 2 used for compression , else "-"
# $4 action: c (encode), b (both encode and decode)
# $5 yes/no mgrec 
# $6 format to decode into if decode specify

source $1/functions.sh

genie_generic_fastq_encoder(){

	fastq_file=$1;
	fastq_file_2=$2
	mgrec_file=$3;
	mgb_file=$4;
	with_mgrec=$5;

	if [ ${fastq_file_2##*.} == "fastq" ] ||  [ ${fastq_file_2##*.} == "fq" ]
	then

        	echo -e "\n Starting encoding FASTQ -> MGB ( $(basename $fastq_file) & $(basename $fastq_file_2) -> $(basename $mgb_file)) \n"

		$genie_path/genie transcode-fastq -i $fastq_file --input-suppl-file $fastq_file_2 -o $mgrec_file
	else

        	echo -e "\n Starting encoding FASTQ -> MGB ( $(basename $fastq_file) -> $(basename $mgb_file)) \n"

		$genie_path/genie transcode-fastq -i $fastq_file -o $mgrec_file
	fi

	register "genie" $mgrec_file

	$genie_path/genie run -i $mgrec_file -o $mgb_file

	register "genie" $mgb_file

	if [ $with_mgrec == "no" ]
        then
                rm $mgrec_file
        fi

}

genie_generic_fastq_decoder(){

	fastq_file=$1;
	fastq_file_2=$2
	mgrec_file=$3;
	mgb_file=$4;
	with_mgrec=$5;

	$genie_path/genie run -i $mgb_file -o $mgrec_file;

	register "genie" $mgrec_file;

	if [ ${fastq_file_2##*.} == "fastq" ] ||  [ ${fastq_file_2##*.} == "fq" ]
	then

		echo -e "\n Starting decoding MGB -> FASTQ ( $(basename $mgb_file) -> $(basename $fastq_file) & $(basename $fastq_file_2) ) \n";

		$genie_path/genie transcode-fastq -i $mgrec_file -o $fastq_file --output-suppl-file $fastq_file_2
		register "genie" $fastq_file_2
	else

		echo -e "\n Starting decoding MGB -> FASTQ ( $(basename $mgb_file) -> $(basename $fastq_file) ) \n";

		$genie_path/genie transcode-fastq -i $mgrec_file -o $fastq_file
	fi

	register "genie" $fastq_file;

	if [ $with_mgrec == "no" ]
        then
                rm $mgrec_file;
        fi

}

genie_generic_sam_encoder(){

        sam_file=$1
	fasta_file=$2
        mgrec_file=$3
        mgb_file=$4
        with_mgrec=$5

        echo -e "\n Starting encoding SAM -> MGB ( $(basename $sam_file) -> $(basename $mgb_file) ) \n";

        $genie_path/genie transcode-sam -i $sam_file -o $mgrec_file --ref $fasta_file

	register "genie" $mgrec_file;

        $genie_path/genie run -i $mgrec_file -o $mgb_file;

	register "genie" $mgb_file;

	if [ $with_mgrec == "no" ]
        then
                rm $mgrec_file;
        fi

}

genie_generic_sam_decoder(){

        sam_file=$1
	fasta_file=$2
        mgrec_file=$3
        mgb_file=$4
        with_mgrec=$5

        echo -e "\n Starting decoding MGB -> SAM ( $(basename $mgb_file) -> $(basename $sam_file) ) \n";

        $genie_path/genie run -i $mgb_file -o $mgrec_file;

	register "genie" $mgrec_file;

        $genie_path/genie transcode-sam -i $mgrec_file -o $sam_file --ref $fasta_file

	register "genie" $sam_file;

	if [ $with_mgrec == "no" ]
        then
                rm $mgrec_file;
        fi

}

used_file=$2
used_file_2=$3
action=$4;
with_mgrec=$5
type_file=$6

if [ ${used_file##*.} == "fastq" ] || [ ${used_file##*.} == "fq" ]
then
	fastq_file_2=$used_file_2
	new_fastq_file_2=${used_file_2%.*}"_decoded.fastq"
else
	fastq_file_2="-"
	new_fastq_file_2="-"
fi

fasta_file=${used_file_2%.*}".fasta"
fastq_file=$used_file
sam_file=${used_file%.*}".sam"
mgrec_file=${used_file%.*}".mgrec"
mgb_file=${used_file%.*}".mgb"

new_fastq_file=${used_file%.*}"_decoded.fastq"
new_sam_file=${used_file%.*}"_decoded.sam"
new_mgrec_file=${used_file%.*}"_decoded.mgrec"

extension_used_file=${used_file##*.}

echo ""
echo $used_file
echo $used_file_2
echo $action
echo $with_mgrec
echo $type_file

echo $fasta_file
echo $fastq_file
echo $fastq_file_2
echo $sam_file
echo $mgrec_file
echo $mgb_file

echo $new_fastq_file
echo $new_fastq_file_2
echo $new_sam_file
echo $new_mgrec_file

echo $extension_used_file
echo ""

case $extension_used_file in

	"fastq" | "fq")

		if [ $action == "c" ]
                then
                        genie_generic_fastq_encoder $fastq_file $fastq_file_2 $mgrec_file $mgb_file $with_mgrec;
                elif [ $action == "b" ]
		then
                        genie_generic_fastq_encoder $fastq_file $fastq_file_2 $mgrec_file $mgb_file $with_mgrec;
                fi

	;;
	"sam" | "bam")

		if [ $action == "c" ]
		then
	                genie_generic_sam_encoder $sam_file $fasta_file $mgrec_file $mgb_file $with_mgrec;
              	elif [ $action == "b" ]
		then
			genie_generic_sam_encoder $sam_file $fasta_file $mgrec_file $mgb_file $with_mgrec
                fi

	;;
	"mgb")

	;;
	*)

                echo"";
                echo "Incorrect format"

        ;;
esac


if [ $extension_used_file == "mgb" ] || [  $action == "b" ]
then

	if [ $extension_used_file == "fastq" ] || [ $extension_used_file == "fq" ] || [ $type_file == "fastq" ] || [ $type_file == "fq" ]
	then
		genie_generic_fastq_decoder $new_fastq_file $fastq_file_2 $new_mgrec_file $mgb_file $with_mgrec
	else
		genie_generic_sam_decoder $new_sam_file $fasta_file $new_mgrec_file $mgb_file $with_mgrec
	fi

fi
