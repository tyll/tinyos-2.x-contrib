COMPONENT=HarvesterC
ifndef LPL_INTERVAL
LPL_INTERVAL = 1000
endif
CFLAGS += -DLPL_INT=$(LPL_INTERVAL)
# use tos libraries
CFLAGS += -I$(TOSDIR)/lib/net/ -I../../tos/lib/net/ctp -I$(TOSDIR)/lib/net/ctp -I$(TOSDIR)/lib/net/4bitle -I.
# use snpk libraries
CFLAGS += -I../../tos/lib/dsn
#external Sensirion Sensor
CFLAGS += -I../../tos/platforms/telosb/chips/sht75
CFLAGS += -I../../tos/lib/gpio
#define cc2420 parameters
#use neighbour sync lpl
CC2420DIR=../../tos/chips/cc2420
CFLAGS += -I$(CC2420DIR) -I$(CC2420DIR)/alarm -I$(CC2420DIR)/control -I$(CC2420DIR)/csma -I$(CC2420DIR)/interfaces -I$(CC2420DIR)/link -I$(CC2420DIR)/lowpan -I$(CC2420DIR)/lpl -I$(CC2420DIR)/packet -I$(CC2420DIR)/receive -I$(CC2420DIR)/spi -I$(CC2420DIR)/transmit -I$(CC2420DIR)/unique -I$(CC2420DIR)/sync
CFLAGS += -DLOW_POWER_LISTENING
CFLAGS += -DTOSH_DATA_LENGTH=37
CFLAGS += -DENABLE_SPI0_DMA
CFLAGS += -I../../tos/platforms/telosa
#LDFLAGS += -Wl,-Map=$(BUILDDIR)/main.map
include $(MAKERULES)
