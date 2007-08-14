#!/bin/bash

ALGORITHMS=$(ls *.out | cut -d . -f 2 | sort | uniq)
DATASETS=$(ls *.out | cut -d . -f 1 | sort | uniq)

echo -n "Algorithm;"
for i in $DATASETS; do
    echo -n "${i};"
done;
echo

for i in $ALGORITHMS; do
    echo -n "${i};"

    for j in $DATASETS; do
	SIZE=$(ls -la ${j}.${i}.out | tr -s " " | cut -d " " -f 5)
	echo -n "${SIZE};"
    done
    echo
done