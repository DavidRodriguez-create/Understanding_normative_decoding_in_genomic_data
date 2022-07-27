#!/bin/bash

go_to(){

	path=$1;
        if [[ $path == *"samtools-"* ]]
        then
                cd versions_samtools/;
                cd ./$path;
	else
		cd $path;
        fi
};

register(){

	printf "$(date) => %s\t$(du -sh $2 | awk '{print $2}') $(basename $2) %s\n" >> $1/History.txt;

};

