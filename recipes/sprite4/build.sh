#!/bin/bash

echo "prefix:" $PREFIX
mkdir -p $PREFIX/bin
builddir=$PREFIX/bin/sprite4_strelka2_install
srcdir=$SRC_DIR/sprite4_strelka2_modified
mkdir -p $builddir

MPICC=`which mpicc || true`
if test -z $MPICC
then
	echo "No-MPI compilation"
	export CC=gcc
	export CXX=g++
else
	echo "MPI compilation"
	export CC=mpicc
	export CXX=mpicxx
	export MPIFLAG=' -DUSE_MPI'
	export CXXFLAGS=' -DUSE_MPI'
fi

if [ "$(uname)" == "Darwin" ]; then
	echo "Compiling sprite4 for OSX"
	export ECFLAG=' -Xpreprocessor'
	export ELFLAG=' -lomp'
	export CXXFLAGS=' -stdlib=libc++'
fi

cp sprite4 sprite4-test sprite4-parsnip-test sprite4-generic-test $PREFIX/bin
cd sprite4_minimap2_modified; make; cp sprite4-minimap2 genFastqIdx $PREFIX/bin; cd ..
echo "Compiling sampa EC ${ECFLAG} EL ${ELFLAG}"
$CC -o $PREFIX/bin/sampa ${MPIFLAG} -DUSE_OMP sampa.c ${ECFLAG} -fopenmp ${ELFLAG}
echo "Compiling parsnip"
$CC -o $PREFIX/bin/parsnip parsnip.c -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate ${MPIFLAG} -DUSE_OMP ${ECFLAG} -fopenmp ${ELFLAG}
$CC -o $PREFIX/bin/bamHeaderFile bamHeaderFile.c -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate

cd $builddir
$srcdir/configure --jobs=4 --prefix=$builddir
make -j1 VERBOSE=1 install
rm -r bootstrap
cd ..

ln -s $builddir/libexec/GetChromDepth $builddir/libexec/starling2 $PREFIX/bin
