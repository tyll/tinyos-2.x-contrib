COMPONENT=NetworkBaseStationC

CFLAGS += -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/drip \
          -I$(TOSDIR)/lib/net/4bitle \
          -I$(TOSDIR)/lib/net/ctp
TFLAGS += -I$(TOSDIR)/../apps/tests/TestDissemination \
          -I.
PFLAGS += -I$(LGLDIR)/libs/BigMsgCTP
PFLAGS += -I../camNode
PFLAGS += -DTOSH_DATA_LENGTH=100
          
include ../../Makerules