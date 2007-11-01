COMPONENT=SensorSchemeAppC

CFLAGS += -I../../tos/lib/SensorScheme \
          -I../../tos/lib/SensorScheme/Interfaces \
          -I../../tos/lib/SensorScheme/Primitives \
          -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/drip \
          -I$(TOSDIR)/lib/net/le \
          -I$(TOSDIR)/lib/net/ctp \


 # the motes group id (default is 0x22).
 # CC2420 channel (default is 26).
 # CC2420 radio transmit power (default is 31)
 # radio packet payload length (default 28). 
PFLAGS += -DDEFINED_TOS_AM_ADDRESS=0x73 -DCC2420_DEF_CHANNEL=23 \
          -DCC2420_DEF_RFPOWER=1 -DTOSH_DATA_LENGTH=28

include $(MAKERULES)

