
SOURCES=serial_tun.c tun_dev.c hashtable.c routing.c nwstate.c \
	logging.c config.c radvd-wrapper.c vty/util.c vty/vty.c

COMMON_SRC = radvd-1.0/log.c radvd-1.0/socket.c radvd-1.0/recv.c radvd-1.0/util.c radvd-1.0/radvd.h \
	radvd-1.0/defaults.h radvd-1.0/pathnames.h \
        radvd-1.0/includes.h
radvd_SOURCES = $(COMMON_SRC) radvd-1.0/timer.c radvd-1.0/send.c radvd-1.0/process.c radvd-1.0/interface.c \
        radvd-1.0/device.c radvd-1.0/device-common.c radvd-1.0/gram.h 

LIBS=../lib6lowpan.a ${TOSROOT}/support/sdk/c/sf/libmote.a
TARGET=ip-driver
INCLUDE=../include/

ifndef GCC
GCC=gcc
endif

TFLAGS=-Wall -g -DPC -D_GNU_SOURCE
TFLAGS+=-I${TOSROOT}/support/sdk/c/sf -I$(INCLUDE) -Iradvd-1.0/ -Ivty/


ifneq ($(filter sim-null,$(MAKECMDGOALS)),)
  TFLAGS+=-DSIM
endif

# CFLAGS+=-DFULL_PATH_INSTALL
all: $(TARGET)

sim: lib
	make $(TARGET) sim-null

sim-null:
	echo Built $(TARGET) for TOSSIM

$(TARGET): $(SOURCES) $(LIBS)
	$(GCC) $(TFLAGS) $(CFLAGS) -o $(TARGET) $(SOURCES) $(radvd_SOURCES) $(LIBS) -lm

clean:
	rm -f $(TARGET)

