COMPONENT=BoilerPlateAppC

#defines
CFLAGS += -DUSE_8MHZ_CRYSTAL

include $(MAKERULES)
ifeq ($(PLATFORM),shimmer2r)
   CFLAGS += -DPWRMUX_UTIL
endif

