#!/bin/bash

for i in ../../linux-bluez/*.accel.csv; do
    LASTTWO=$(echo $i | cut -d ':' -f 5- | tr -d : | sed -e 's/\.accel//g')
    ln -s $i $LASTTWO
done;