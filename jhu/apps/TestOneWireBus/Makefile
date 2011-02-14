COMPONENT=TestC

CFLAGS+=-DMAX_ONEWIRE_DEVICES=2
CFLAGS+=-DTEST_FIRST_OW_ID=0x6b1c33bLL
CFLAGS+=-DTEST_SECOND_OW_ID=0x7a7dc3bLL

CFLAGS += -IdummyOW
CFLAGS += -I$(OSHAN_ROOT)/tinyos/tos/lib/onewire
CFLAGS += -I$(OSHAN_ROOT)/tinyos/tos/lib/onewire/interfaces
CFLAGS += -I$(OSHAN_ROOT)/tinyos/tos/chips/ds1825

#TODO: does this have to go in here? it seems like the wrong place.
PFLAGS += -I$(OSHAN_ROOT)/tinyos/tos/platforms/surf/hardware/onewire

PFLAGS += -I$(TOSDIR)/lib/serialprintf

include $(MAKERULES)
