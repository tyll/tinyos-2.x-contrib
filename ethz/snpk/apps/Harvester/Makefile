COMPONENT=HarvesterC
CFLAGS += -I$(TOSDIR)/lib/net/ -I$(TOSDIR)/lib/net/ctp -I$(TOSDIR)/lib/net/le -I.
CFLAGS += -I../../tos/lib/dsn
CFLAGS += -DLOW_POWER_LISTENING
# include bugfixes for dma spi
CFLAGS += -I../../tos/chips/msp430/usart -I../../tos/interfaces
# include trace scheduler
CFLAGS += -I../../tos/system
CFLAGS += -DCC2420_DEF_RFPOWER=31 -DCC2420_DEF_CHANNEL=23
# CFLAGS += -DTOSH_DATA_LENGTH=33
CFLAGS += -g
include $(MAKERULES)
setname:
	cp `pwd`/build/telosb/main.ihex `pwd`/build/telosb/harvesterTreeInfo.ihex
loadall:
	`pwd`/loadall.sh
loadbase:
	`pwd`/loadbase.sh
	