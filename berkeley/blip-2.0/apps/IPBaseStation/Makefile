COMPONENT=BaseStationC

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
CFLAGS += -DTOSH_DATA_LENGTH=125
CFLAGS += -DCC2420_DEF_CHANNEL=15
CFLAGS += -DPACKET_LINK
PFLAGS += -DCC2420_HW_ACKNOWLEDGEMENTS
# CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS
# CFLAGS += -DCC2420_NO_ADDRESS_RECOGNITION
# CFLAGS += -DPRINTFUART_ENABLED

CFLAGS += -I$(TOSROOT)/support/sdk/c/blip/interface -I$(TOSROOT)/tos/lib/serial

include $(MAKERULES)

