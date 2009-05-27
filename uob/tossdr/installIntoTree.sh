#!/bin/bash

mkdir -p $TOSROOT/tos/platforms/micaz/sdr/
cp tos/platforms/micaz/sdr/.platform $TOSROOT/tos/platforms/micaz/sdr/
cp tos/platforms/micaz/sdr/platform_hardware.h $TOSROOT/tos/platforms/micaz/sdr/

mkdir -p $TOSROOT/tos/platforms/mica/sdr/
cp tos/platforms/mica/sdr/* $TOSROOT/tos/platforms/mica/sdr/

mkdir -p $TOSROOT/tos/platforms/micaz/chips/cc2420/sdr/
cp tos/platforms/micaz/chips/cc2420/sdr/* $TOSROOT/tos/platforms/micaz/chips/cc2420/sdr/

mkdir -p $TOSROOT/tos/chips/cc2420/sdr/
cp tos/chips/cc2420/sdr/*.nc $TOSROOT/tos/chips/cc2420/sdr/

mkdir -p $TOSROOT/tos/chips/cc2420/control/sdr
cp tos/chips/cc2420/control/sdr/*.nc $TOSROOT/tos/chips/cc2420/control/sdr/

mkdir -p $TOSROOT/tos/chips/cc2420/csma/sdr
cp tos/chips/cc2420/csma/sdr/*.nc $TOSROOT/tos/chips/cc2420/csma/sdr/

mkdir -p $TOSROOT/tos/chips/cc2420/packet/sdr
cp tos/chips/cc2420/packet/sdr/*.nc $TOSROOT/tos/chips/cc2420/packet/sdr/

mkdir -p $TOSROOT/tos/chips/cc2420/receive/sdr
cp tos/chips/cc2420/receive/sdr/*.nc $TOSROOT/tos/chips/cc2420/receive/sdr/

mkdir -p $TOSROOT/tos/chips/cc2420/transmit/sdr
cp tos/chips/cc2420/transmit/sdr/*.nc $TOSROOT/tos/chips/cc2420/transmit/sdr/

mkdir -p $TOSROOT/tos/lib/tossdr
cp tos/lib/tossdr/* $TOSROOT/tos/lib/tossdr/

mkdir -p $TOSROOT/tos/chips/atm128/sdr
cp tos/chips/atm128/sdr/* $TOSROOT/tos/chips/atm128/sdr/

mkdir -p $TOSROOT/tos/chips/atm128/pins/sdr
cp tos/chips/atm128/pins/sdr/* $TOSROOT/tos/chips/atm128/pins/sdr/

mkdir -p $TOSROOT/tos/chips/atm128/spi/sdr
cp tos/chips/atm128/spi/sdr/* $TOSROOT/tos/chips/atm128/spi/sdr/

mkdir -p $TOSROOT/tos/chips/atm128/timer/sdr
cp tos/chips/atm128/timer/sdr/* $TOSROOT/tos/chips/atm128/timer/sdr/

mkdir -p $TOSROOT/support/make/
cp support/make/sdr.extra $TOSROOT/support/make/

