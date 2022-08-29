#!/bin/bash

#install Spring

git clone https://github.com/shubhamchandak94/Spring.git
cd Spring
mkdir build
cd build
cmake ..
make

echo -e "\n-------------- DONE ---------------\n"
echo -e "Spring exec in $(pwd) directory."
echo -e "FaStore execs in $dir_F directory\n"

