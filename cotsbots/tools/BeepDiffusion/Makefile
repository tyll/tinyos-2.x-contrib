TOS = ../../tos
PACKAGE = BeepDiffusion
APP=$(TOS)/../apps/BeepDiffusion
LIB=$(TOS)/lib
MIG = mig java

# List of message classes to build
MSGS = BeepDiffusionResetMsg.java
INITIAL_TARGETS = $(MSGS)
OTHER_CLEAN = cleanmig

ROOT = ../
include $(ROOT)/Makefile.include

BeepDiffusionResetMsg.java:
	$(MIG) -java-classname=$(PACKAGE).BeepDiffusionResetMsg $(LIB)/BeepDiffusionMsg.h BeepDiffusionResetMsg -o $@

cleanmig:
	rm -f $(MSGS)
