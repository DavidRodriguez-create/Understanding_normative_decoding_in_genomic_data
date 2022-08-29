#!/bin/bash

source ../functions.sh

mkdir samtools_releases;
cd samtools_releases;

for version in ${samtools_versions[@]}
do
	dir_name=samtools-$version;
	if [ ! -d $dir_name ]
	then
		path="https://github.com/samtools/samtools/releases/download/"$version"/samtools-"$version".tar.bz2";
		curl -L -O $path;
		tar -xf samtools-$version.tar.bz2;
		cd samtools-$version;
		./configure;
		make;
		cd ..;
		rm samtools-$version.tar.bz2;
	fi
done

cd ..;
echo "";
echo "All samtools releases installed";


