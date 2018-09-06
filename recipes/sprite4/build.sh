#!/bin/bash

echo "prefix:" $PREFIX
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/bin/strelka2_install
builddir=$PREFIX/strelka2_install
srcdir=$SRC_DIR/sprite4_strelka2_modified
mkdir -p $builddir
export CC=mpicc
export CXX=mpicxx
export CXXFLAGS=-DUSE_MPI

cd sprite4_minimap2_modified; make; cp minimap2 genFastqIdx $PREFIX/bin; cd ..
$CC -o $PREFIX/sampa -DUSE_MPI -DUSE_OMP sampa.c -fopenmp
$CC -o $PREFIX/parsnip parsnip.c -DUSE_MPI -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate -DUSE_OMP -fopenmp
$CC -o $PREFIX/bamHeaderFile bamHeaderFile.c -DUSE_MPI -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate

cd $builddir
$srcdir/configure --jobs=1 --prefix=$builddir
make -j1 install
rm -r bootstrap
cd ..
