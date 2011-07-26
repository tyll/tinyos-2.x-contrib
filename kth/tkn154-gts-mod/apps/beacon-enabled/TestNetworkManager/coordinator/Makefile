COMPONENT=TestGtsAppC
CFLAGS += -I$(shell pwd)/..  
PFLAGS += -DIEEE154_SCAN_DISABLED \
		  -DIEEE154_BEACON_SYNC_DISABLED
		  
CFLAGS += -I$(TOSDIR)/lib/printf
		  

CFLAGS += -I$(shell pwd)/..

# To use the TKN15.4 MAC instead of a platform's default MAC protocol first
# include the TinyOS "Makerules" file as usual ...
include $(MAKERULES)

include $(TOSCONTRIB)/kth/tkn154-gts-mod/tos/lib/mac/tkn154/Makefile.include

# ... and then include the TKN15.4 "Makefile.include" file. That's all.
# Hint: type "make <platform> verbose" to see the aggregate include path.
include $(TOSDIR)/lib/mac/tkn154/Makefile.include
