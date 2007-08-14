#!/bin/bash

ALGORITHMS="huffman huffman_diff huffman_whole huffman_whole_diff"
NODES=$(echo -e "4D08\t\t4D09\t\t4D0B\t\t4EBC\t\t4EBE\t\t4EBF")

declare -a TOTAL_SIZES

printf "% 20s\t%s\t\tTotal\n" " " "$NODES"
for i in $ALGORITHMS; do
    printf "% 20s" ${i}
    TOTAL_SIZE=0;
    NO=0;
    for j in $NODES; do
	SIZES=$(ls -l *${i}.${j}* | tr -s " " | cut -d " " -f 5)
	SIZE=0;
	for k in $SIZES; do
	    SIZE=$(($SIZE + $k))
	done;
#	printf "\t% 11d" ${SIZE}
	printf "\t% 4.2f" `echo ${SIZE}/1024/1024 | bc -l`
	TOTAL_SIZES[$NO]=$((${TOTAL_SIZES[$NO]} + $SIZE))

	TOTAL_SIZE=$(($TOTAL_SIZE + $SIZE));
	NO=$(($NO + 1))
    done;
    printf "\t% 11d\n" ${TOTAL_SIZE}
done;

printf "% 20s" "Total"

for i in ${TOTAL_SIZES[*]}; do
    printf "\t% 11d" $i
done;
echo
