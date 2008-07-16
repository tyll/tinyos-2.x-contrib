
SOURCES=serial_tun.c tun_dev.c hashtable.c routing.c nwstate.c ../printpacket.c logging.c
LIBS=../lib6lowpan.a ${TOSROOT}/support/sdk/c/sf/libmote.a 
TARGET=serial_tun

ifndef GCC
GCC=gcc
endif

TFLAGS=-Wall -g -DPC
TFLAGS+=-I${TOSROOT}/support/sdk/c/sf -I..

all:
	cd .. && make lib6lowpan.a
	make $(TARGET)


$(TARGET): $(SOURCES) $(LIBS)
	$(GCC) $(TFLAGS) -o $(TARGET) $(SOURCES) $(LIBS) -lm

clean:
	rm serial_tun

