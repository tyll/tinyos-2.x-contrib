# -*- Makefile -*-

obj-m += ixpci.o
ixpci-objs := pci.o proc.o

obj-m += ixpci1202.o
ixpci1202-objs := pci1202.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	rm -rf *.o *.ko *~ 
