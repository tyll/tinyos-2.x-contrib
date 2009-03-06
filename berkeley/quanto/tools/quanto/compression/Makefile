CC = gcc
QUANTO_LOG = $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog
INCLUDES = $(QUANTO_LOG)/QuantoLogCompressedMyUartWriter.h libquantocode.h

CFLAGS = -g -Wall #-DEG_DEBUG
LDFLAGS = -L.
INCLUDEFLAGS = -I$(QUANTO_LOG)

all: check_quanto_root quanto_decode
quanto_decode: quanto_decode.c libquantocode.a $(INCLUDES)
	$(CC) $(CFLAGS) $(INCLUDEFLAGS) $< $(LDFLAGS) -lquantocode -o $@

test: test.c libquantocode.a libquantocode.h
	$(CC) $(CFLAGS) $(INCLUDEFLAGS) $< $(LDFLAGS) -lquantocode -o $@
   
libquantocode.a : libquantocode.o
	ar -rcs $@ $?

libquantocode.o : libquantocode.c libquantocode.h
	$(CC) -c $(CFLAGS) libquantocode.c -o $@

clean:
	rm *.o *.a quanto_decode

.PHONY: check_quanto_root
check_quanto_root:
ifndef QUANTO_ROOT
	@echo "Please define QUANTO_ROOT, we need to grab a couple of files from there!"
	@exit 1
endif


