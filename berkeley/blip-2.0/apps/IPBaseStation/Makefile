COMPONENT=BaseStationC

BLIP_L2_MTU = 125
MAKECMDGOALS := $(MAKECMDGOALS) blip2


# radio options.  channel settings will be overridden by the driver
# CFLAGS += -DCC2420_DEF_RFPOWER=4

# if you're worried about your interface mote crashing, enable this to
# turn on a hardware watchdog that will reset it if it does.  CFLAGS
# += -DBLIP_WATCHDOG
#
# debugging
#

# defs for snooping-- handy for debugging LPL, etc.
# CFLAGS += -DCC2420_NO_UNIQUE

# set for max MPDU
CFLAGS += -DCC2420_DEF_CHANNEL=15
CFLAGS += -DPACKET_LINK
PFLAGS += -DCC2420_HW_ACKNOWLEDGEMENTS
# CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS
# CFLAGS += -DCC2420_NO_ADDRESS_RECOGNITION
# CFLAGS += -DPRINTFUART_ENABLED

CFLAGS += -I$(LOWPAN_ROOT)/support/sdk/c/blip/interface -I$(LOWPAN_ROOT)/tos/lib/serial

include $(MAKERULES)

