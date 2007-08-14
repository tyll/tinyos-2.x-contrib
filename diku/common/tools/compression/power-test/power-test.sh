#!/bin/bash

if [ $# -lt 1 ]; then
    echo "You must specify the algorithm being used."
    exit 1;
fi;

ALGORITHM=$1;

if [ $# -gt 1 ]; then
    echo "Performing testrun"
    TESTRUN=true;
else
    TESTRUN=false;
fi;

for i in *.csv; do
    FILENAME=$(echo $i | cut -d . -f 1)
    if $TESTRUN; then
	OUTPUTFILE=$FILENAME.$ALGORITHM.out
    else
	OUTPUTFILE="";
    fi;

    ../node-comm $i $OUTPUTFILE | tee $FILENAME.$ALGORITHM.log

    if $TESTRUN; then
	if ! ../decompress ../$ALGORITHM $i < $OUTPUTFILE; then
	    exit 1;
	fi;
    fi;
done;
