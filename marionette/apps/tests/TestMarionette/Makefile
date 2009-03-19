COMPONENT=TestMarionetteAppC

###############
##IF THIS DOESN'T COMPILE:
# 1. make sure that you sourced the file tinyos-2.x-contrib/marionette/support/sdk/python/tinyos/marionette/util/pytosProfile
# 2. make sure that pytosProfile sets the variable MARIONETTEROOT correctly
# 3. try the following: cp tinyos-2.x-contrib/marionette/support/make/*.extra tinyos-2.x/support/make/


GOALS += marionette

PFLAGS += -DTOSH_MAX_TASKS_LOG2=8

CFLAGS += -I$(MARIONETTEROOT)/tos/lib/Rpc
CFLAGS += -I$(MARIONETTEROOT)/tos/lib/RamSymbols

TOSMAKE_PATH += $(MARIONETTEROOT)/support/make

MAKERULES := $(TOSROOT)/support/make/Makerules
include $(MAKERULES)
