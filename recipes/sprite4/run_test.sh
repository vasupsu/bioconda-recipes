#!/bin/bash

echo "Creating FASTQ index"
sprite4 idx $PREFIX/bin/sprite4_strelka2_install/share/demo/strelka/data/NA12891_demo20.fq

echo "Aligning"
sprite4 map -s 1 $PREFIX/bin/sprite4_strelka2_install/share/demo/strelka/data/demo20.fa $PREFIX/bin/sprite4_strelka2_install/share/demo/strelka/data/NA12891_demo20.fq

echo "Sorting"
sprite4 sampa -s 1 $PREFIX/bin/sprite4_strelka2_install/share/demo/strelka/data/demo20.fa

echo "Calling variants"
sprite4 varcall -s 1 $PREFIX/bin/sprite4_strelka2_install/share/demo/strelka/data/demo20.fa
