COMPONENT = PowerNetAppC
BOOTLOADER=tosboot
include $(MAKERULES)
PFLAGS += -DCC2420_DEF_CHANNEL=26
PFLAGS += -DTOSH_DATA_LENGTH=100
CFLAGS += -I./ctp \
          -I./4bitle \
          -I../../tos/sensorboards/PowerNetDriver \
	        -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/4bitle \
          -I$(TOSDIR)/lib/net/ctp
