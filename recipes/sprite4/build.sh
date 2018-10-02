#!/bin/bash

echo "prefix:" $PREFIX
mkdir -p $PREFIX/bin
builddir=$PREFIX/bin/sprite4_strelka2_install
srcdir=$SRC_DIR/sprite4_strelka2_modified
mkdir -p $builddir
export CC=mpicc
export CXX=mpicxx
export CXXFLAGS=-DUSE_MPI

cp sprite4 $PREFIX/bin
cd sprite4_minimap2_modified; make; cp sprite4-minimap2 genFastqIdx $PREFIX/bin; cd ..
$CC -o $PREFIX/bin/sampa -DUSE_MPI -DUSE_OMP sampa.c -fopenmp
$CC -o $PREFIX/bin/parsnip parsnip.c -DUSE_MPI -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate -DUSE_OMP -fopenmp
$CC -o $PREFIX/bin/bamHeaderFile bamHeaderFile.c -DUSE_MPI -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate

cd $builddir
$srcdir/configure --jobs=4 --prefix=$builddir
make -j4 install
rm -r bootstrap
cd ..

ln -s $builddir/libexec/GetChromDepth $builddir/libexec/starling2 $PREFIX/bin
