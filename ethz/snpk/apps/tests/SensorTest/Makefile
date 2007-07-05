COMPONENT=SensorTestC
CFLAGS += -I../../../tos/lib/dsn -I../../../tos/system
#external Sensirion Sensor
CFLAGS += -I../../../tos/platforms/telosb/chips/sht75
CFLAGS += -I../../../tos/lib/gpio
# include bugfixes for dma spi
CFLAGS += -I../../../tos/chips/msp430/usart -I../../../tos/interfaces
# add debug symbols
CFLAGS += -g
# DSN output to usb
CFLAGS += -DUSART=1
include $(MAKERULES)
