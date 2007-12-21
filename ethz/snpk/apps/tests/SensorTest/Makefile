COMPONENT=SensorTestC
CFLAGS += -I../../../tos/lib/dsn -I../../../tos/system
#external Sensirion Sensor
CFLAGS += -I../../../tos/platforms/telosb/chips/sht75
CFLAGS += -I../../../tos/lib/gpio
# add debug symbols
CFLAGS += -g
# DSN output to usb
CFLAGS += -DUSART=1
include $(MAKERULES)
