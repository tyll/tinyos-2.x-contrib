COMPONENT=TestCoordinatorC
#PFLAGS += -DPRINTF_BUFFER_SIZE=600
#CFLAGS += -I$(TOSDIR)/lib/printf

IEEE154_EXTENDED_ADDRESS = 0xFFEEDDCCBBAA0099LL
ifdef IEEE154_EXTENDED_ADDRESS
PFLAGS += -DIEEE154_EXTENDED_ADDRESS=$(IEEE154_EXTENDED_ADDRESS)
endif

CFLAGS += -I$(TOSROOT)/tos/lib/mac/tkn154 \
	  -I$(TOSROOT)/tos/lib/mac/tkn154/dummies \
	  -I$(TOSROOT)/tos/lib/mac/tkn154/interfaces/MCPS \
	  -I$(TOSROOT)/tos/lib/mac/tkn154/interfaces/MLME \
	  -I$(TOSROOT)/tos/lib/mac/tkn154/interfaces/private \
	  -I$(TOSROOT)/tos/lib/mac/tkn154/interfaces/public \
	  -I../../../../../tos/lib/net/zigvigo \
	  -I../../../../../tos/lib/net/zigvigo/interfaces \
	  -I../../../../../tos/lib/net/zigvigo/interfaces/private \
	  -I$(TOSDIR)/platforms/micaz/mac/tkn154 \
	  -I$(TOSDIR)/platforms/telosb/mac/tkn154 \
	  -I$(TOSDIR)/platforms/telosb/mac/tkn154/timer \
	  -I$(TOSDIR)/chips/cc2420_tkn154

include $(MAKERULES)
