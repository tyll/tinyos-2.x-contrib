COMPONENT=HarvesterC
# use tos libraries
CFLAGS += -I$(TOSDIR)/lib/net/ -I$(TOSDIR)/lib/net/ctp -I$(TOSDIR)/lib/net/le -I.
# use snpk libraries
CFLAGS += -I../../tos/lib/dsn -I../../tos/system
# include bugfixes for dma spi
CFLAGS += -I../../tos/chips/msp430/usart -I../../tos/interfaces
#external Sensirion Sensor
CFLAGS += -I../../tos/platforms/telosb/chips/sht75
CFLAGS += -I../../tos/lib/gpio
#define cc2420 parameters
CFLAGS += -DLOW_POWER_LISTENING
#CFLAGS += -DMAX_LPL_CCA_CHECKS=200 -DMIN_SAMPLES_BEFORE_DETECT=10
CFLAGS += -DMIN_SAMPLES_BEFORE_DETECT=1
CFLAGS += -DCC2420_HW_ACKNOWLEDGEMENTS
# CFLAGS += -DTOSH_DATA_LENGTH=33
# add debug symbols
CFLAGS += -g
include $(MAKERULES)
