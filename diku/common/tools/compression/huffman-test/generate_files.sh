#!/bin/bash

FILES="4D08 4D09 4D0B 4EBC 4EBE 4EBF"

ALGORITHMS="huffman huffman_diff huffman_whole huffman_whole_diff"

for BASEFILE in $FILES; do
    pushd ../huffman
    make clean
    make CODEBASE=$BASEFILE.csv
    popd

    for i in $FILES; do
	for ALG in $ALGORITHMS; do
	    ../compress ../$ALG $i.csv > $i.$ALG.$BASEFILE.csv
	done;
    done;
done


