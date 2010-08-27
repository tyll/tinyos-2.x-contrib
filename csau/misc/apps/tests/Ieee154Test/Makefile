COMPONENT=src/Ieee154TestC

CFLAGS += -Isrc

#CFLAGS += -DUSE_AM
#CFLAGS += -DTFRAMES_ENABLED

CFLAGS += -DPACKET_LINK
CFLAGS += -DPACKET_LINK_RETRIES=10
CFLAGS += -DPACKET_LINK_DELAY=0

CFLAGS += -DPRINTF_BUFFER_SIZE=1000
#CFLAGS += -I$(TOSDIR)/lib/printf
# if print should be disabled
CFLAGS += -I$(TOSCONTRIB)/csau/misc/tos/types

CFLAGS += -I$(TOSCONTRIB)/csau/misc/tos/system
CFLAGS += -I$(TOSCONTRIB)/csau/misc/tos/lib/tossim
CFLAGS += -I$(TOSDIR)/chips/cc2420/link
CFLAGS += -I$(TOSDIR)/chips/cc2420/unique
CFLAGS += -I$(TOSDIR)/chips/cc2420/lpl
CFLAGS += -I$(TOSDIR)/chips/cc2420/interfaces

BUILD_EXTRA_DEPS += 
CLEAN_EXTRA = simbuild build doc app.xml 

include $(MAKERULES)