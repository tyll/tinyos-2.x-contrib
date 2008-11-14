
SOURCES=serial_tun.c tun_dev.c hashtable.c routing.c nwstate.c logging.c config.c
LIBS=../lib6lowpan.a ${TOSROOT}/support/sdk/c/sf/libmote.a 
TARGET=serial_tun

ifndef GCC
GCC=gcc
endif

TFLAGS=-Wall -g -DPC
TFLAGS+=-I${TOSROOT}/support/sdk/c/sf -I..


ifneq ($(filter sim-null,$(MAKECMDGOALS)),)
  TFLAGS+=-DSIM
endif

# CFLAGS+=-DFULL_PATH_INSTALL
all: lib
	make $(TARGET)

sim: lib
	make $(TARGET) sim-null

sim-null:
	echo Built $(TARGET) for TOSSIM

$(TARGET): $(SOURCES) $(LIBS)
	$(GCC) $(TFLAGS) $(CFLAGS) -o $(TARGET) $(SOURCES) $(LIBS) -lm

lib:
	cd .. && make lib6lowpan.a

clean:
	rm serial_tun

