
FILE=$1

perl -pe 's/DEBUG.*\: //' < $FILE | sort -n -k 1 -k 2 -k 3 -k 4