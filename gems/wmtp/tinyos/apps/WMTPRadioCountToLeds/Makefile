# Path to WMTP
PFLAGS += -I../../tos/lib/net/wmtp
PFLAGS += -I../../tos/lib/net/wmtp/interfaces
PFLAGS += -I../../tos/lib/net/wmtp/modules
PFLAGS += -I../../tos/lib/net/wmtp/adapter

#CFLAGS += -I$(TOSDIR)/lib/printf

COMPONENT=RadioCountToLedsAppC
#BUILD_EXTRA_DEPS = RadioCountMsg.py RadioCountMsg.class

#RadioCountMsg.py: RadioCountToLeds.h
#	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=RadioCountMsg RadioCountToLeds.h radio_count_msg -o $@

#RadioCountMsg.class: RadioCountMsg.java
#	javac RadioCountMsg.java

#RadioCountMsg.java: RadioCountToLeds.h
#	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RadioCountMsg RadioCountToLeds.h radio_count_msg -o $@


include $(MAKERULES)

