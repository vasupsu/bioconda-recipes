#!/bin/bash


##strictly use anaconda build environment
#CXX=${PREFIX}/bin/g++

#to fix problems with zlib
export C_INCLUDE_PATH=$C_INCLUDE_PATH:${PREFIX}/include
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:${PREFIX}/include
export LIBRARY_PATH=$LIBRARY_PATH:${PREFIX}/lib

(
	cd ext
	rm -fr htslib
	git clone git://github.com/samtools/htslib
	cd htslib
	git checkout 1.4
	autoheader
	autoconf
	make -j
)

#echo "g++"
#g++ -v || true
#echo "c++"
#c++ -v || true
#echo "CXX"
#$CXX -v || true

make VERBOSE=1
mkdir -p ${PREFIX}/bin
cp ococo ${PREFIX}/bin/
mkdir -p ${PREFIX}/share/man/man1
cp ococo.1 ${PREFIX}/share/man/man1/

