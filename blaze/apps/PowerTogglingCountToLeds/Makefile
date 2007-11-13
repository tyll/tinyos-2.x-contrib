COMPONENT=RadioCountToLedsAppC

CFLAGS+=-DCC2500_DEFAULT_CHANNEL=20
CFLAGS+=-DCC1100_DEFAULT_CHANNEL=20



CFLAGS+=-I../../tos/chips/blazeradio
CFLAGS+=-I../../tos/chips/blazeradio/acks
CFLAGS+=-I../../tos/chips/blazeradio/alarm
CFLAGS+=-I../../tos/chips/blazeradio/am
CFLAGS+=-I../../tos/chips/blazeradio/cc1100
CFLAGS+=-I../../tos/chips/blazeradio/cc2500
CFLAGS+=-I../../tos/chips/blazeradio/csma
CFLAGS+=-I../../tos/chips/blazeradio/init
CFLAGS+=-I../../tos/chips/blazeradio/interfaces
CFLAGS+=-I../../tos/chips/blazeradio/link
CFLAGS+=-I../../tos/chips/blazeradio/packet
CFLAGS+=-I../../tos/chips/blazeradio/receive
CFLAGS+=-I../../tos/chips/blazeradio/select
CFLAGS+=-I../../tos/chips/blazeradio/spi
CFLAGS+=-I../../tos/chips/blazeradio/transmit
CFLAGS+=-I../../tos/chips/blazeradio/unique

CFLAGS+=-I../../tos/platforms/tmote2500
CFLAGS+=-I../../tos/platforms/tmote2500/chips
CFLAGS+=-I../../tos/platforms/tmote2500/chips/ccxx00

#CFLAGS+=-I../../tos/platforms/tmote1100/
#CFLAGS+=-I../../tos/platforms/tmote1100/chips
#CFLAGS+=-I../../tos/platforms/tmote1100/chips/ccxx00

BUILD_EXTRA_DEPS = RadioCountMsg.py RadioCountMsg.class


include $(MAKERULES)

