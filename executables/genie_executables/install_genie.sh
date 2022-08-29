#! /usr/bin/env bash

sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update

if [ !$(command -v gcc)  ] || [ !$(command -v g++)  ]
then
	sudo apt-get update
	sudo apt-get install gcc-11 g++-11
else
	if [ $(gcc --version | head -n 1 | awk 'NF{ print $NF }' | cut -d "." -f1) < 11 ] || [ $(g++ --version | head -n 1 | awk 'NF{ print $NF }' | cut -d "." -f1) < 11 ]

	then
		sudo apt-get install gcc-11 g++-11
	fi
fi

# (to make it the default compilator)
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 20 --slave /usr/bin/g++ g++ /usr/bin/g++-11

#get zlib and htslib
sudo apt-get update
sudo apt-get install autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev

git clone https://github.com/samtools/htslib.git
cd htslib
autoreconf -i  # Build the configure script and install files it uses
git submodule update --init --recursive
./configure    # Optional but recommended, for choosing extra functionality
make
sudo make install
cd ..
rm -r htslib

#just in case cmake is not installed yet
sudo apt update
sudo apt install cmake

#get genie
git clone -b develop --single-branch https://github.com/mitogen/genie.git
cd genie
mkdir build
cd build
CC=gcc-11 CXX=/usr/bin/g++-11 cmake ..
make
cd bin

echo "----------- DONE -----------"
echo -e "genie executable in directory: $(pwd)\n"
