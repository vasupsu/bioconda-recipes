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
	export ECFLAG=' -Xpreprocessor'
	export ELFLAG=' -lomp'
	export CXXFLAGS=' -stdlib=libc++'
fi

cp sprite4 sprite4-test $PREFIX/bin
cd sprite4_minimap2_modified; make; cp sprite4-minimap2 genFastqIdx $PREFIX/bin; cd ..
echo "Compiling sampa EC ${ECFLAG} EL ${ELFLAG}"
$CC -o $PREFIX/bin/sampa -DUSE_OMP sampa.c ${ECFLAG} -fopenmp ${ELFLAG}
echo "Compiling parsnip"
$CC -o $PREFIX/bin/parsnip parsnip.c -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate -DUSE_OMP ${ECFLAG} -fopenmp ${ELFLAG}
$CC -o $PREFIX/bin/bamHeaderFile bamHeaderFile.c -I${PREFIX}/include/htslib -L${PREFIX}/lib -lhts -lz  -lbz2 -llzma -lpthread -ldeflate

cd $builddir
$srcdir/configure --jobs=4 --prefix=$builddir
make -j1 VERBOSE=1 install
rm -r bootstrap
cd ..

ln -s $builddir/libexec/GetChromDepth $builddir/libexec/starling2 $PREFIX/bin
