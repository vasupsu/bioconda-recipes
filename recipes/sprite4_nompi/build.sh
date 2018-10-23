#!/bin/bash

echo "prefix:" $PREFIX
mkdir -p $PREFIX/bin
builddir=$PREFIX/bin/sprite4_strelka2_install
srcdir=$SRC_DIR/sprite4_strelka2_modified
mkdir -p $builddir
export CC=gcc
export CXX=g++

if [ "$(uname)" == "Darwin" ]; then
	echo "Compiling sprite4 for OSX"
	export CXXFLAGS=' -stdlib=libc++'
fi
export MPIFLAG=${CXXFLAGS}

cp sprite4 $PREFIX/bin
cd sprite4_minimap2_modified; make; cp sprite4-minimap2 genFastqIdx $PREFIX/bin; cd ..
$CC -o $PREFIX/bin/sampa -DUSE_OMP sampa.c -fopenmp
$CC -o $PREFIX/bin/parsnip parsnip.c -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate -DUSE_OMP -fopenmp
$CC -o $PREFIX/bin/bamHeaderFile bamHeaderFile.c -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate

cd $builddir
$srcdir/configure --jobs=4 --prefix=$builddir
make -j1 VERBOSE=1 install
rm -r bootstrap
cd ..

ln -s $builddir/libexec/GetChromDepth $builddir/libexec/starling2 $PREFIX/bin
