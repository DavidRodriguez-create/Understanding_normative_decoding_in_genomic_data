#!/bin/bash

origin="/home/alumno/TFG/Understanding_normative_decoding_in_genomic_data/executables"
genie_path="/home/alumno/TFG/Understanding_normative_decoding_in_genomic_data/executables/genie_executables/genie/build/bin"
spring_path="/home/alumno/TFG/Understanding_normative_decoding_in_genomic_data/executables/spring_executables/Spring/build"
scalce_path="/home/alumno/TFG/Understanding_normative_decoding_in_genomic_data/executables/scalce_executables/scalce"
samtools_path="/home/alumno/TFG/Understanding_normative_decoding_in_genomic_data/executables/samtools_executables/samtools_versions/samtools-"

samtools_versions=( 1.15.1 1.15 1.14 1.13 1.12 1.11 1.10 1.9 1.8 1.7 1.6 1.5 1.4.1 1.4 1.3.1 1.3 1.2 )

htslib_prefix(){
	return $(./samtools --version | sed '2q;d' | awk '{ print $2"_"$3}')
}

register(){
	cd $(dirname $2)
	printf "$(date) =>   $1   $(ll $2 | awk '{print $5}') $(basename $2) %s\n" >> $origin/../History.txt
	cd -

};

function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "\n$prompt\n"
    while true
    do
        # list all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            index=$(( $index + 1 ))
        done
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
        echo "";
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}

