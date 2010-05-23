# Path to WMTP
PFLAGS += -I../../../tos/lib/net/wmtp
PFLAGS += -I../../../tos/lib/net/wmtp/interfaces
PFLAGS += -I../../../tos/lib/net/wmtp/modules

# Supress warnings
#PFLAGS += -w 

PFLAGS += -DTOSH_DATA_LENGTH=60

CFLAGS += -I$(TOSDIR)/lib/printf

CLEAN_EXTRA = $(BUILD_EXTRA_DEPS) _TOSSIM.dll *.csv

COMPONENT ?= TestWmtpAppC
include $(MAKERULES)
