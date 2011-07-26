COMPONENT=TestGtsAppC
PFLAGS += -DIEEE154_BEACON_TX_DISABLED 

CFLAGS += -I$(shell pwd)/..
CFLAGS += -I$(TOSDIR)/lib/printf
PFLAGS += -DPRINTF_BUFFER_SIZE=512

		  

CFLAGS += -I$(shell pwd)/..

# To use the TKN15.4 MAC instead of a platform's default MAC protocol first
# include the TinyOS "Makerules" file as usual ...
include $(MAKERULES)

include $(TOSCONTRIB)/kth/tkn154-gts-mod/tos/lib/mac/tkn154/Makefile.include

# ... and then include the TKN15.4 "Makefile.include" file. That's all.
# Hint: type "make <platform> verbose" to see the aggregate include path.
include $(TOSDIR)/lib/mac/tkn154/Makefile.include

