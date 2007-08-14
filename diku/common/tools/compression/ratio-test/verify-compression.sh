#!/bin/bash

for i in *.out; do
    DATASET=$(echo $i | cut -d . -f 1)
    ALGORITHM=$(echo $i | cut -d . -f 2)
    echo "Decompressing $i, with dataset $DATASET and algorithm $ALGORITHM";
    if ! ../decompress ../$ALGORITHM ${DATASET}.csv < $i; then
	exit 1;
    fi;
done;