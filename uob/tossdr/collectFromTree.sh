#!/bin/bash

# copy SDR components from tree
mkdir -p tos/platforms/micaz/sdr/
cp /opt/tinyos-2.x/tos/platforms/micaz/sdr/.platform tos/platforms/micaz/sdr/
cp /opt/tinyos-2.x/tos/platforms/micaz/sdr/platform_hardware.h tos/platforms/micaz/sdr/

mkdir -p tos/platforms/mica/sdr/
cp $TOSROOT/tos/platforms/mica/sdr/* tos/platforms/mica/sdr/

mkdir -p tos/platforms/micaz/chips/cc2420/sdr/
cp $TOSROOT/tos/platforms/micaz/chips/cc2420/sdr/* tos/platforms/micaz/chips/cc2420/sdr/

mkdir -p tos/chips/cc2420/sdr/
cp /opt/tinyos-2.x/tos/chips/cc2420/sdr/*.nc tos/chips/cc2420/sdr/

mkdir -p tos/chips/cc2420/control/sdr
cp /opt/tinyos-2.x/tos/chips/cc2420/control/sdr/*.nc tos/chips/cc2420/control/sdr/

mkdir -p tos/chips/cc2420/csma/sdr
cp /opt/tinyos-2.x/tos/chips/cc2420/csma/sdr/*.nc tos/chips/cc2420/csma/sdr/

mkdir -p tos/chips/cc2420/packet/sdr
cp /opt/tinyos-2.x/tos/chips/cc2420/packet/sdr/*.nc tos/chips/cc2420/packet/sdr/

mkdir -p tos/chips/cc2420/receive/sdr
cp /opt/tinyos-2.x/tos/chips/cc2420/receive/sdr/*.nc tos/chips/cc2420/receive/sdr/

mkdir -p tos/chips/cc2420/transmit/sdr
cp /opt/tinyos-2.x/tos/chips/cc2420/transmit/sdr/*.nc tos/chips/cc2420/transmit/sdr/

mkdir -p tos/lib/tossdr
cp $TOSROOT/tos/lib/tossdr/* tos/lib/tossdr/

mkdir -p tos/chips/atm128/sdr
cp $TOSROOT/tos/chips/atm128/sdr/* tos/chips/atm128/sdr/

mkdir -p tos/chips/atm128/pins/sdr
cp $TOSROOT/tos/chips/atm128/pins/sdr/* tos/chips/atm128/pins/sdr/

mkdir -p tos/chips/atm128/spi/sdr
cp $TOSROOT/tos/chips/atm128/spi/sdr/* tos/chips/atm128/spi/sdr/

mkdir -p tos/chips/atm128/timer/sdr
cp $TOSROOT/tos/chips/atm128/timer/sdr/* tos/chips/atm128/timer/sdr/

# copy SDR target from tree
mkdir -p support/make/
cp /opt/tinyos-2.x/support/make/sdr.extra support/make/

# copy SDR executables from tree
cp /opt/tinyos-2.x/apps/tests/TestAM/sdr2tos.py python/
cp /opt/tinyos-2.x/apps/tests/TestAM/sdr_handling.py python/

# copy modified UCLA code
cp -r /home/mab/src/external/cgran/orig/gnuradio-802.15.4-demodulation/ ucla/

# copy modified ncc
cp /usr/bin/ncc tools/tinyos/
