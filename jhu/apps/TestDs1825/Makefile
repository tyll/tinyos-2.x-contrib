COMPONENT=TestC
CONTRIB_ROOT?=/home/carlson/tinyos-2.x-contrib/jhu
CFLAGS+=-DMAX_ONEWIRE_DEVICES=2

CFLAGS += -I$(CONTRIB_ROOT)/tos/lib/onewire
CFLAGS += -I$(CONTRIB_ROOT)/tos/lib/onewire/interfaces
CFLAGS += -I$(CONTRIB_ROOT)/tos/chips/ds1825

#These should typically be included by the .platform file, but
#  are included here so that tinyos-contrib and the core tinyos code
#  can play together nicely
PFLAGS += -I$(CONTRIB_ROOT)/tos/platforms/telosb
PFLAGS += -I$(CONTRIB_ROOT)/tos/platforms/telosb/hardware/onewire

PFLAGS += -I$(TOSDIR)/lib/printf
include $(MAKERULES)

