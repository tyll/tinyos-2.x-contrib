#!/bin/sh

LINKS="
support/make/avr/usbasp.extra
support/make/iwing-mrf.target
tos/chips/atm328
tos/chips/mrf24j40
tos/platforms/iwing-mrf
"

#
# Some sanity checks
#
if [ ! $TOSROOT ]; then
    echo Error: environment TOSROOT not defined
    exit 1
fi

for i in $LINKS; do
    if [ ! -d `dirname $TOSROOT/$i` ]; then
        echo -n 'Error: '
        echo '$TOSROOT' does not seem to point to a valid TinyOS directory
        echo Directory $TOSROOT/`dirname $i` does not exist
        exit 2
    fi
done

#
# Create symlinks
#
for i in $LINKS; do
    echo Creating symlink $TOSROOT/$i
    if [ -e $TOSROOT/$i ]; then
        echo -n 'Warning: '
        echo $TOSROOT/$i already exists
    else
        ln -s `pwd`/$i $TOSROOT/$i
    fi
done
echo 'Done.'
