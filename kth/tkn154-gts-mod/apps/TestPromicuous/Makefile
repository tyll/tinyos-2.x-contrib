COMPONENT=TestPromiscuousAppC
PFLAGS += -DPRINTF_BUFFER_SIZE=1000
CFLAGS += -I$(TOSDIR)/lib/printf
CFLAGS += -DIEEE154_SCAN_DISABLED \
		  -DIEEE154_BEACON_SYNC_DISABLED \
		  -DIEEE154_BEACON_TX_DISABLED \
		  -DIEEE154_RXENABLE_DISABLED \
		  -DIEEE154_ASSOCIATION_DISABLED \
		  -DIEEE154_DISASSOCIATION_DISABLED \
		  -DIEEE154_COORD_REALIGNMENT_DISABLED \
		  -DIEEE154_COORD_BROADCAST_DISABLED
		  

CFLAGS += -I$(shell pwd)/..

# To use the TKN15.4 MAC instead of a platform's default MAC protocol first
# include the TinyOS "Makerules" file as usual ...
include $(MAKERULES)

include $(TOSCONTRIB)/kth/tkn154-gts-mod/tos/lib/mac/tkn154/Makefile.include

# ... and then include the TKN15.4 "Makefile.include" file. That's all.
# Hint: type "make <platform> verbose" to see the aggregate include path.
include $(TOSDIR)/lib/mac/tkn154/Makefile.include

