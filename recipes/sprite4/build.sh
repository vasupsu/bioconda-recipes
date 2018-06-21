#!/bin/bash

mkdir -p $PREFIX/bin
export CC=mpicc
export CXX=mpicxx
export CXXFLAGS=-DUSE_MPI

cd minimap2_parallelio_circular; make; cp minimap2 $PREFIX/bin; cd ..
