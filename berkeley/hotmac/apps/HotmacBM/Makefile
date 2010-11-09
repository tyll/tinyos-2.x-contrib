COMPONENT=RadioCountToLedsAppC

# by the default Hotmac is set up to use a single channel, set by this #def
# CFLAGS += -DCC2420_DEF_CHANNEL=26

# find the printf header, enable DMA (you want this)
CFLAGS += -I. -DENABLE_SPI0_DMA

# some debugs (you problably also want this, although it's not required).
CFLAGS += -DPRINTFUART_ENABLED 

include $(MAKERULES)
