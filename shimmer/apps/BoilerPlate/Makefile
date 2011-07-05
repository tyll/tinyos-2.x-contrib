COMPONENT=BoilerPlateAppC

#defines
CFLAGS += -DUSE_8MHZ_CRYSTAL

include $(MAKERULES)
ifeq ($(PLATFORM),shimmer2r)
   CFLAGS += -DPWRMUX_UTIL
   CFLAGS += -DSHIMMER_VER=2
else ifeq ($(PLATFORM),shimmer2)
   CFLAGS += -DSHIMMER_VER=1
else ifeq ($(PLATFORM),shimmer)
   CFLAGS += -DSHIMMER_VER=0
endif
