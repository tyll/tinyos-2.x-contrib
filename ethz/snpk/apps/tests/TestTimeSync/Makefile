#Low Power
#CFLAGS += -DCC2420_DEF_RFPOWER=2

PFLAGS += -DCC2420_DEF_CHANNEL=20 
#PFLAGS += -DTOSH_DATA_LENGTH=30
PFLAGS += -I../../../tos/lib/dsn -DUSART=1
PFLAGS += -I../../../tos/lib/net/TimeSync 

ifndef COMPONENT
   COMPONENT=TestTimeSyncAppC
endif


include $(MAKERULES)


