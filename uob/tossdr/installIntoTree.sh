#!/bin/bash

mkdir -p $TOSROOT/tos/platforms/micaz/sdr/
cp tos/platforms/micaz/sdr/.platform $TOSROOT/tos/platforms/micaz/sdr/
cp tos/platforms/micaz/sdr/platform_hardware.h $TOSROOT/tos/platforms/micaz/sdr/

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

mkdir -p $TOSROOT/support/make/
cp support/make/sdr.extra $TOSROOT/support/make/

