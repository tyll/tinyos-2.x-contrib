
SOURCES=lib6lowpan.c lib6lowpanIP.c  lib6lowpanFrag.c


###############
##
## Use these for PC
ifndef GCC
GCC=gcc
endif
ifndef AR
AR=ar
endif

CFLAGS=-DPC -g -I$(LOWPAN_ROOT)/tos/lib/net/b6lowpan/
TEST=testhc.c

###############
##
## These for msp430
# GCC=msp430-gcc
# AR=msp430-ar
# TEST=msp_test.c
# CFLAGS=-DMSP

LIB=lib6lowpan.a
OBJS=$(SOURCES:.c=.o)

all: $(LIB)
	cd tunnel && make


$(LIB): $(OBJS)
	$(AR) crv $(LIB) $(OBJS)

test: $(SOURCES) $(TEST) $(LIB)
	$(GCC) -o $@ $(TEST) $(CFLAGS) $(LIB) printpacket.c

%.o: %.c
	$(GCC) -o $@ $< $(CFLAGS) -c

clean:
	rm -f test $(OBJS) $(LIB)

deps:
	./deps.awk $(SOURCES) >> Makefile

########################################################################
lib6lowpan.o: lib6lowpan.c 6lowpan.h ip.h lib6lowpan.h
lib6lowpanIP.o: lib6lowpanIP.c 6lowpan.h ip.h lib6lowpan.h
lib6lowpanFrag.o: lib6lowpanFrag.c tunnel/IEEE154.h 6lowpan.h ip.h lib6lowpan.h
