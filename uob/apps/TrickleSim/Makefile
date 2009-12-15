COMPONENT=TrickleSimAppC
BUILD_EXTRA_DEPS = sim/TrickleSimMsg.py
CLEAN_EXTRA = sim/TrickleSimMsg.py

CFLAGS += -I./interfaces/
CFLAGS += -I$(TOSROOT)/tos/lib/net/

sim/TrickleSimMsg.py: TrickleSim.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=TrickleSimMsg TrickleSim.h trickle_sim_msg -o $@

include $(MAKERULES)

