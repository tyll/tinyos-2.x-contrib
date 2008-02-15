COMPONENT=TinyCOPSDemoAppC
CONTRIBDIR=$(shell pwd)/../../tos

#include tinycops
CFLAGS += -I$(CONTRIBDIR)/lib/tinycops \
          -I$(CONTRIBDIR)/lib/tinycops/attributes \
          -I$(CONTRIBDIR)/lib/tinycops/net \
          -I$(CONTRIBDIR)/lib/tinycops/csec \
          -I$(CONTRIBDIR)/lib/tinycops/asec \
          -I$(CONTRIBDIR)/lib/tinycops/gateway

# include net2 libraries
CFLAGS += -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/4bitle \
          -I$(TOSDIR)/lib/net/ctp \
          -I$(TOSDIR)/lib/net/drip

include $(MAKERULES)
