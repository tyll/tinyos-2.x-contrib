#!/bin/bash

TREND=trend-20050723/trend
FIFOPATH=/tmp/

# D X Blå #117bff
# D Y Rød
# D Z Grøn
# A X Sort
# A Y Gul

GEOMETRY=$(xdpyinfo | grep dimensions | cut -d ':' -f 2 | tr -s ' ' | cut -d ' ' -f 2)

HEIGHT=$(echo $GEOMETRY | cut -d 'x' -f 2)
WIDTH=$(echo $GEOMETRY | cut -d 'x' -f 1)

echo "Screen is ${WIDTH}x${HEIGHT}"

WINDOWS="$FIFOPATH/accel_a_x ffffff Analog X-axis
$FIFOPATH/accel_a_y ffff00 Analog Y-axis
$FIFOPATH/accel_a_z ff0000 Analog Z-axis"
# $FIFOPATH/accel_d_y 117bf Digital Y-axis
# $FIFOPATH/accel_d_z 00ff00 Digital Z-axis"

WINNO=$(echo "$WINDOWS" | wc -l)

echo "We are going to create ${WINNO} windows"

WINHEIGHT=$[ $HEIGHT / $WINNO ]
WINPOS=0

echo "$WINDOWS" | while read i; do
	FILENAME=$(echo $i | cut -d ' ' -f 1)
	COLOR=$(echo $i | cut -d ' ' -f 2)
	TITLE=$(echo $i | cut -d ' ' -f 3-)

	$TREND -geometry ${WIDTH}x${WINHEIGHT}+0+${WINPOS} -F \
		-I \#${COLOR} \
		-t "${TITLE}" -s -d -v -f d -- ${FILENAME} 300 0 8200 &
#		-t "${TITLE}" -s -d -v -f d -- ${FILENAME} 300 -5 5 &

	WINPOS=$[ $WINPOS + $WINHEIGHT ]
done;

