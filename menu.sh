#!/bin/bash

source ./executables/functions.sh

#https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script/563226#563226 - Guss

options=(
"Genie"
"Gzip"
"Samtools"
"Scalce"
"Spring"
"Quit"
)

read_var(){

	read -p "$1 `echo $'\n  > '; echo ''`" var
	echo $var

}

selected_choice=""
cont=""

clear
choose_from_menu "Compression tools menu:" selected_choice "${options[@]}"

while [[ $selected_choice != "Quit" ]]
do

	case $selected_choice in
	 "Genie")

#		menu_ge

		;;
	"Spring")

		input_file=$(read_var "Input file: ")
                echo ""
                input_file_2=$(read_var "Input file: (if needed, else '-')")
                echo ""
                action=$(read_var "Actions: c (encode) or b (both encode & decode) (if needed, else '-') ")
                echo ""
                delete_after_end=$(read_var "Delete intermidiate files of the process? (if possible) ")
                echo ""

		$origin/spring_executables/generic_spring.sh $origin $input_file $input_file_2 $action $delete_after_end

                ;;
	"Samtools")

		input_file=$(read_var "Input file: ")
		echo ""
		input_file_2=$(read_var "Input file: (if needed, else '-') ")
		echo ""
		action=$(read_var "Actions: c (encode) or b (both encode & decode) (if needed, else '-') ")
		echo ""
		delete_after_end=$(read_var "Delete intermidiate files of the process? (if needed, else '-') ")
		echo ""
		encoder_version=$(read_var "Encoder version: (example: 1.15.1) (if needed, else '-') ")
	 	echo ""
		decoder_version=$(read_var "Decoder version: (if needed, else '-') ")
		echo ""

		$origin/samtools_executables/generic_samtools.sh $origin $input_file $input_file_2 $action $delete_after_end $encoder_version $decoder_version

                ;;
	"Scalce")

		input_file=$(read_var "Input file: ")
                echo ""
		input_type=$(read_var "File type: s (single) or p (pair-end) ")
                echo ""
                action=$(read_var "Actions: c (encode) or b (both encode & decode) (if needed, else '-') ")
                echo ""
                delete_after_end=$(read_var "Delete intermidiate files of the process? (if needed, else '-') ")
                echo ""

		$origin/scalce_executables/generic_scalce.sh $origin $input_file $input_type $action $delete_after_end

	;;
	esac

	echo ""
	read -p "Continue? (y/n) " cont

	if [ $cont == "no" ] || [ $cont == "n" ]
	then
		selected_choice="Quit"
	else
		clear
		choose_from_menu "Compression tools menu:" selected_choice "${options[@]}"
	fi
done

