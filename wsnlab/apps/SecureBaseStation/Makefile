COMPONENT=SecureBaseStationC

CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS
CFLAGS += -DCC2420_NO_ADDRESS_RECOGNITION

PFLAGS += -DCC2420_DEF_CHANNEL=12
PFLAGS += -DTOSH_DATA_LENGTH=114

# default to security disabled
#SECURE=Y
ifeq ($(SECURE),Y)
     $(info INFO: Compiling with secure send/receive)
     PFLAGS += -DSECURE
     CFLAGS += -DCC2420_HW_SECURITY
     PFLAGS += -DDEFAULT_AM_TYPE=0x99
else
     $(info INFO: Compiling in insecure mode, define 'SECURE=Y' to enable)
endif

include $(MAKERULES)

