COMPONENT=OctopusAppC
CFLAGS += -I$(TOSDIR)/lib/net/ -I$(TOSDIR)/lib/net/ctp -I$(TOSDIR)/lib/printf -I$(TOSDIR)/lib/net/le -I.
# PST - 10 oct 2008, someone forgot to include a dissemination ...
CFLAGS += -I$(TOSDIR)/lib/net/drip
BUILD_EXTRA_DEPS = OctopusSentMsg.class OctopusCollectedMsg.class
MIGFILES = OctopusCollectedMsg.java OctopusCollectedMsg.class OctopusSentMsg.java OctopusSentMsg.class

OctopusCollectedMsg.class: OctopusCollectedMsg.java
	javac OctopusCollectedMsg.java
OctopusCollectedMsg.java: Octopus.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=OctopusCollectedMsg Octopus.h octopus_collected_msg -o $@

	
OctopusSentMsg.class: OctopusSentMsg.java
	javac OctopusSentMsg.java
OctopusSentMsg.java: Octopus.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=OctopusSentMsg Octopus.h octopus_sent_msg -o $@

include $(MAKERULES)

migclean:
	rm -rf $(MIGFILES)
