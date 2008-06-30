COMPONENT=SyncMacEnduranceC
# use snpk libraries
CFLAGS += -I../../../tos/lib/dsn
CC2420DIR=../../../tos/chips/cc2420
CFLAGS += -I$(CC2420DIR) -I$(CC2420DIR)/alarm -I$(CC2420DIR)/control -I$(CC2420DIR)/csma -I$(CC2420DIR)/interfaces -I$(CC2420DIR)/link -I$(CC2420DIR)/lowpan -I$(CC2420DIR)/lpl -I$(CC2420DIR)/packet -I$(CC2420DIR)/receive -I$(CC2420DIR)/spi -I$(CC2420DIR)/transmit -I$(CC2420DIR)/unique -I$(CC2420DIR)/sync
CFLAGS += -I../../../tos/platforms/telosa
CFLAGS += -DCC2420_DEF_RFPOWER=5
#define cc2420 parameters
CFLAGS += -DCC2420_DEF_CHANNEL=12
CFLAGS += -DCC2420SYNC_DEBUG_PINS -DCC2420SYNC_DEBUG_LEDS -DCC2420SYNC_NO_HISTORY_REFILL
CFLAGS += -DUSART=1
# -DCC2420SYNC_DEBUG
CFLAGS += -DLOW_POWER_LISTENING
CFLAGS += -DENABLE_SPI0_DMA
CFLAGS += -g
include $(MAKERULES)
loadall:
	../../Harvester/loadall.sh
