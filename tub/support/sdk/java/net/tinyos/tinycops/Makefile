TOS = $(shell ncc -print-tosdir)
ROOT = ../../..
CONTRIBDIR = $(ROOT)/../../../tos
MIG = mig java
LIB = $(CONTRIBDIR)/lib/tinycops
CTP = $(TOS)/lib/net/ctp
PACKAGE = net.tinyos.tinycops
MSGS = SubscriptionMsg.java CtpMsg.java
INITIAL_TARGETS = $(MSGS)
OTHER_CLEAN = cleanmig

include $(ROOT)/Makefile.include


NotificationMsg.java: $(LIB)/TinyCOPS.h
	$(MIG) -java-classname=$(PACKAGE).NotificationMsg -I$(CTP) $(LIB)/TinyCOPS.h notification -o $@

SubscriptionMsg.java: $(LIB)/TinyCOPS.h
	$(MIG) -java-classname=$(PACKAGE).SubscriptionMsg -I$(CTP) $(LIB)/TinyCOPS.h subscription -o $@

CtpMsg.java: $(LIB)/net/CtpWrapper.h
	$(MIG) -java-classname=$(PACKAGE).CtpMsg -I$(CTP) $(LIB)/net/CtpWrapper.h ctp_msg -o $@

cleanmig:
	rm -f $(MSGS) $(CONSTS) platforms.properties
