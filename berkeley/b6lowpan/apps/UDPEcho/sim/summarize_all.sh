
DIR=$1
OUT=$2


for i in $(find $DIR -name flows.txt -print); do
    perl summarize.pl $i >> $OUT
done