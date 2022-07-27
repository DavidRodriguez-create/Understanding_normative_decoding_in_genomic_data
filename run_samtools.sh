#!/bin/bash

directory=$1;
prefix=$(./samtools --version | sed '2q;d' | awk '{ print $2"_"$3}');

sam_file=$2;
bam_file=$directory"/"$prefix"_"${sam_file%.*}".bam";
cram_file=$directory"/"$prefix"_"${sam_file%.*}".cram";

# This script should create the BAM and CRAM files from a SAM file
# to later on be decoded by the lastest hstlib version. All register in $directory/History.txt

echo "Starting coding SAM -> BAM ( $sam_file -> $(basename $bam_file) )";

pv $directory/$sam_file | ./samtools view -S -b > $bam_file;
register $directory $bam_file;

echo "Starting coding BAM -> CRAM ( $(basename $bam_file) -> $(basename $cram_file) )";

pv $bam_file | ./samtools view -T $directory/${sam_file%.*}.fasta -C -o $cram_file;
register $directory $cram_file;

echo "Coding finished. Check $directory/History.txt";
