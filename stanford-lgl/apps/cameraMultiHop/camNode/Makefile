COMPONENT=cameraJpegTestC
CFLAGS += -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/drip \
          -I$(TOSDIR)/lib/net/4bitle \
          -I$(TOSDIR)/lib/net/ctp #-DNO_DEBUG

PFLAGS += -I$(LGLDIR)/support/sdk/c/compress
PFLAGS += -I$(LGLDIR)/libs/BigMsgCTP
CFLAGS += -DTOSH_DATA_LENGTH=100
CFLAGS += -DPXA27X_FREQ=208
#CFLAGS += -Wcast-align -Wpadded -Wpacked
include ../../Makerules
