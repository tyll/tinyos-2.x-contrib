#!/bin/bash
for i in `seq 1 30`;
do
	sleep 3;
	./sfcollect localhost 9001 3;
	#./sfcollect localhost 9001 19;
	cp data.txt data.txt.3.$i
done    
