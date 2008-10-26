
IXPCIPATH=kernel-driver

CFLAGS=-g -O0 -I$(IXPCIPATH) -I. -Wall

LIBDAQ=pci1202_lib.c

all: test calibrate calibrate_magic test_setup view-data

test: test.c libdaq.a
	gcc $(CFLAGS) -o $@ $< libdaq.a

test_setup: test_setup.c libdaq.a
	gcc $(CFLAGS) -o $@ $< libdaq.a -lncurses

calibrate: calibrate.c libdaq.a
	gcc $(CFLAGS) -o $@ $< libdaq.a -lncurses

calibrate_magic: calibrate_magic.c libdaq.a
	gcc $(CFLAGS) -o $@ $< libdaq.a -lncurses

view-data: view-data.c libdaq.a
	gcc $(CFLAGS) -o $@ $< libdaq.a -lncurses


libdaq.a: $(LIBDAQ:.c=.o)
	ar rc $@ $^

clean:
	rm -f *.o *.a *~ 