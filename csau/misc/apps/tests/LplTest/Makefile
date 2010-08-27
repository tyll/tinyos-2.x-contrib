COMPONENT=src/LplTestC

CFLAGS += -Isrc

##### Config #####

CFLAGS += -DPERIOD=1024
CFLAGS += -DRECEIVER=2

#CFLAGS += -DCC2420_DEF_RFPOWER=31

#CFLAGS += -DCC2420_HW_ACKNOWLEDGEMENTS
#CFLAGS += -DCC2420_HW_ADDRESS_RECOGNITION

#CFLAGS += -DLOW_POWER_LISTENING
CFLAGS += -DLPL_DEF_LOCAL_WAKEUP=51
CFLAGS += -DLPL_DEF_REMOTE_WAKEUP=51

#CFLAGS += -DQUICKTIME
CFLAGS += -I$(TOSCONTRIB)/csau/misc/tos/lib/timemeasure

##### End #####

## TOSSIM
CFLAGS += -I$(TOSCONTRIB)/csau/misc/tos/lib/tossim
CFLAGS += -I$(TOSDIR)/chips/cc2420/link
CFLAGS += -I$(TOSDIR)/chips/cc2420/unique
CFLAGS += -I$(TOSDIR)/chips/cc2420/lpl
CFLAGS += -I$(TOSDIR)/chips/cc2420/interfaces

CFLAGS += -I$(TOSCONTRIB)/csau/misc/tos/lib/timer

CFLAGS += -DPRINTF_BUFFER_SIZE=4000
#CFLAGS += -I$(TOSDIR)/lib/printf
# if print should be disabled
CFLAGS += -I$(TOSCONTRIB)/csau/misc/tos/types

BUILD_EXTRA_DEPS += 
CLEAN_EXTRA = simbuild build doc app.xml 

include $(MAKERULES)