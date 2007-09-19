COMPONENT=OctopusAppC
CFLAGS += -I$(TOSDIR)/lib/net/ -I$(TOSDIR)/lib/net/ctp -I$(TOSDIR)/lib/net/le -I.
BUILD_EXTRA_DEPS = OctopusSentMsg.class OctopusCollectedMsg.class
MIGFILES = OctopusCollectedMsg.java OctopusCollectedMsg.class OctopusSentMsg.java OctopusSentMsg.class


OctopusCollectedMsg.java: Octopus.h
	mig -target=null -java-classname=OctopusCollectedMsg java Octopus.h octopus_collected_msg -o $@
OctopusCollectedMsg.class: OctopusCollectedMsg.java
	javac OctopusCollectedMsg.java
	

OctopusSentMsg.java: Octopus.h
	mig -target=null -java-classname=OctopusSentMsg java Octopus.h octopus_sent_msg -o $@
OctopusSentMsg.class: OctopusSentMsg.java
	javac OctopusSentMsg.java


include $(MAKERULES)

migclean:
	rm -rf $(MIGFILES)