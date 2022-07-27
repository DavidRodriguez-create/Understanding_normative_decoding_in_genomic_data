#!/bin/bash

# Entering the name of the CRAM file with the extension, decodes both, 
# BAM and CRAM files to SAM files. All register in $directory/History.txt

directory="/home/alumno/TFG/samples/G15511.HCC1143.1";
prefix=$(./samtools --version | sed '2q;d' | awk '{ print $2"_"$3}');

register(){
       printf "$(date) => " >> $directory/History.txt;
       printf "%s\t$(du -sh $1 | awk '{print $1}') $(basename $1) %s\n" >> $directory/History.txt;
};

cram_file=$1;
bam_file=$directory"/"${cram_file%.*}".bam";
sam_file_bam=$directory"/"$prefix"_from_BAM_"${cram_file%.*}".sam";
sam_file_cram=$directory"/"$prefix"_from_CRAM_"${cram_file%.*}".sam";
new_bam_file=$directory"/"$prefix"_from_CRAM_"${cram_file%.*}".bam";

echo "Starting decoding BAM -> SAM ( $(basename $bam_file) -> "$prefix"_from_BAM_"${cram_file%.*}".sam )";

pv $bam_file | ./samtools view -h -o $sam_file_bam;
register $sam_file_bam;
rm $sam_file_bam;
rm $bam_file;

echo "Starting decoding CRAM -> BAM -> SAM ( $cram_file -> $(basename $bam_file) -> $(basename $sam_file) )";

pv $directory/$cram_file | ./samtools view -T $directory/G15511.HCC1143.1.fasta -b -o $new_bam_file;
register $new_bam_file;
rm $directory/$cram_file;

pv $new_bam_file | ./samtools view -h -o $sam_file_cram;
register $sam_file_cram;

rm $sam_file_cram;
rm $new_bam_file;

echo "Decoding finished. Check $directory/History.txt";
