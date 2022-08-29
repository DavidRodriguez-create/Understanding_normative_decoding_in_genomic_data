#!/bin/bash

# $1 functions.sh path
# $2 full path for sam file 
# $3 full path for fasta file, else "-"
# $4 action: c (encode), b (both encode and decode)
# $5 yes/no delete files after completed
# $6 encoder version
# $7 decoder version

source $1/functions.sh

samtools_bam_encoder(){

	version=$1
	sam_file=$2
	bam_file=$3

	echo ""
	echo "Starting coding SAM -> BAM ( $sam_file -> $(basename $bam_file) )";

	pv $sam_file | $samtools_path$version/samtools view -S -b > $bam_file;
	register "samtools" $bam_file;

}

samtools_bam_decoder(){

	version=$1
        sam_file=$2
        bam_file=$3
	delete_after_end=$4

	echo ""
        echo "Starting decoding BAM -> SAM ( $(basename $bam_file) -> $(basename $sam_file_bam) )";

	pv $bam_file | $samtools_path$version/samtools view -h -o $sam_file;
	register "samtools" $sam_file;

	if [ $delete_after_end == "yes" ] || [ $delete_after_end == "y" ]
	then
		rm $bam_file
	fi

}

samtools_cram_encoder(){

	version=$1
        sam_file=$2
        bam_file=$3
	cram_file=$4
	fasta_file=$5
	delete_after_end=$6

	samtools_bam_encoder $version $sam_file $bam_file

	echo ""
	echo "Starting coding BAM -> CRAM ( $(basename $bam_file) -> $(basename $cram_file) )";

	pv $bam_file | $samtools_path$version/samtools view -T $fasta_file -C -o $cram_file;
	register "samtools" $cram_file;

	if [ $delete_after_end == "yes" ] || [ $delete_after_end == "y" ]
        then
                rm $bam_file
        fi

}

samtools_cram_decoder(){

	version=$1
        sam_file=$2
        bam_file=$3
        cram_file=$4
        fasta_file=$5
	delete_after_end=$6

	echo ""
	echo "Starting decoding CRAM -> BAM -> SAM ( $cram_file -> $(basename $new_bam_file) -> $(basename $sam_file) )"

	pv $cram_file | ./samtools view -T $fasta_file -b -o $bam_file;
	register "samtools" $bam_file

	if [ $delete_after_end == "yes" ] || [ $delete_after_end == "y" ]
        then
                rm $cram_file
        fi

	samtools_bam_decoder $version $sam_file $bam_file $delete_after_end

}

used_file=$2
fasta_file=$3
action=$4
delete_after_end=$5
encoder_version=$6
decoder_version=$7

dir=$(dirname $used_file)
name=$(basename $used_file)

sam_file=${used_file%.*}".sam"
bam_file=$dir"samtools_"$encoder_version"_"$name".bam"
cram_file=$dir"samtools_"$encoder_version"_"$name".cram"

new_sam_file=$dir"samtools_"$decoder_version"_from_samtools_"$encoder_version"_"$name".sam"
new_bam_file=$dir"samtools_"$decoder_version"_from_samtools_"$encoder_version"_"$name".bam"

case ${used_file##*.} in

	"sam")
		if [ $type_file == "bam" ]
		then
			if [ $action == "c" ]
	                then
	                        samtools_bam_encoder $encoder_version $sam_file $bam_file
	                else
				samtools_bam_encoder $encoder_version $sam_file $bam_file
	                        samtools_bam_decoder $decoder_version $new_sam_file $bam_file $delete_after_end
	                fi
		else
			if [ $action == "c" ]
                        then
                                samtools_cram_encoder $encoder_version $sam_file $bam_file $cram_file $fasta_file $delete_after_end
                        else
				samtools_cram_encoder $encoder_version $sam_file $bam_file $cram_file $fasta_file $delete_after_end
                                samtools_cram_decoder $decoder_version $new_sam_file $new_bam_file $cram_file $fasta_file $delete_after_end
                        fi
		fi
	;;
	"bam")
		samtools_bam_decoder $decoder_version $new_sam_file $bam_file $delete_after_end
	;;
	"cram")
		samtools_cram_decoder $decoder_version $new_sam_file $new_bam_file $cram_file $fasta_file $delete_after_end
	;;
	*)

		echo"";
		echo "Incorrect format"

	;;
esac
