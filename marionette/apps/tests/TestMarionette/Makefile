COMPONENT=TestMarionetteAppC

GOALS += marionette

#GOALS += nucleus
#PFLAGS += -DUSE_NUCLEUS
#TINYOS_NP ?= BNP

PFLAGS += -DTOSH_MAX_TASKS_LOG2=8
MARIONETTE_ROOT=../../..

CFLAGS += -I$(MARIONETTE_ROOT)/tos/lib/Rpc
CFLAGS += -I$(MARIONETTE_ROOT)/tos/lib/RamSymbols

TOSMAKE_PATH += $(MARIONETTE_ROOT)/support/make

MAKERULES := $(TOSROOT)/support/make/Makerules
include $(MAKERULES)
