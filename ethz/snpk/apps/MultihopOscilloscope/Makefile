COMPONENT=$(TOSROOT)/apps/MultihopOscilloscope/MultihopOscilloscopeAppC
CFLAGS += -I$(TOSROOT)/apps/MultihopOscilloscope
CFLAGS += -I$(TOSDIR)/lib/net/ -I$(TOSDIR)/lib/net/ctp  -I$(TOSDIR)/lib/net/4bitle

# LPL_DEFAULT_SLEEP_INTERVAL is the radio sleep time, given in milliseconds 
CFLAGS += -DLOW_POWER_LISTENING -DLPL_DEFAULT_SLEEP_INTERVAL=250

CC2420DIR=../../tos/chips/cc2420
CFLAGS += -I$(CC2420DIR) -I$(CC2420DIR)/alarm -I$(CC2420DIR)/control -I$(CC2420DIR)/csma -I$(CC2420DIR)/interfaces -I$(CC2420DIR)/link -I$(CC2420DIR)/lowpan -I$(CC2420DIR)/lpl -I$(CC2420DIR)/packet -I$(CC2420DIR)/receive -I$(CC2420DIR)/spi -I$(CC2420DIR)/transmit -I$(CC2420DIR)/unique -I$(CC2420DIR)/sync
CFLAGS += -DTOSH_DATA_LENGTH=34
CFLAGS += -DENABLE_SPI0_DMA
CFLAGS += -I../../tos/platforms/telosa
include $(MAKERULES)
