#!/bin/bash

go_to(){

	file=$1;
        if [[ $file == *"samtools-"* ]]
        then
                cd versions_samtools/;
                cd ./$file;
        fi
};

register(){

	printf "$(date) => %s\t$(du -sh $2 | awk '{print $2}') $(basename $2) %s\n" >> $1/History.txt;

};

