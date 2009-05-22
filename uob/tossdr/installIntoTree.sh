#!/bin/bash

mkdir -p tos/platforms/micaz/sdr/
cp $(TOSROOT)/tos/platforms/micaz/sdr/.platform tos/platforms/micaz/sdr/
cp $(TOSROOT)/tos/platforms/micaz/sdr/platform_hardware.h tos/platforms/micaz/sdr/

mkdir -p tos/chips/cc2420/sdr/
cp $(TOSROOT)/tos/chips/cc2420/sdr/*.nc tos/chips/cc2420/sdr/

mkdir -p tos/chips/cc2420/control/sdr
cp $(TOSROOT)/tos/chips/cc2420/control/sdr/*.nc tos/chips/cc2420/control/sdr/

mkdir -p tos/chips/cc2420/csma/sdr
cp $(TOSROOT)/tos/chips/cc2420/csma/sdr/*.nc tos/chips/cc2420/csma/sdr/

mkdir -p tos/chips/cc2420/packet/sdr
cp $(TOSROOT)/tos/chips/cc2420/packet/sdr/*.nc tos/chips/cc2420/packet/sdr/

mkdir -p tos/chips/cc2420/receive/sdr
cp $(TOSROOT)/tos/chips/cc2420/receive/sdr/*.nc tos/chips/cc2420/receive/sdr/

mkdir -p tos/chips/cc2420/transmit/sdr
cp $(TOSROOT)/tos/chips/cc2420/transmit/sdr/*.nc tos/chips/cc2420/transmit/sdr/

mkdir -p support/make/
cp $(TOSROOT)/support/make/sdr.extra support/make/

