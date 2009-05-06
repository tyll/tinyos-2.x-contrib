COMPONENT=cameraJpegTestC
PFLAGS = -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/drip \
          -I$(TOSDIR)/lib/net/4bitle \
          -I$(TOSDIR)/lib/net/ctp #-DNO_DEBUG

PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/support/sdk/c/compress
PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/tos/lib/BigMsgCTP
PFLAGS += -DTOSH_DATA_LENGTH=100
PFLAGS += -DPXA27X_FREQ=208
include ../../Makerules
