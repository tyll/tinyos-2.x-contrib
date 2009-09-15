COMPONENT=BaselineAppC
//CFLAGS += -I$(TOSDIR)/lib/net/ctp -I$(TOSDIR)/lib/net/le -I.

CONTRIBDIR=$(shell pwd)/../../tos

CFLAGS += -I$(CONTRIBDIR)/lib/net -I$(CONTRIBDIR)/lib/net/Arbutus  -I.

BUILD_EXTRA_DEPS = dataMsg.class entryMsg.class statsMsg.class

dataMsg.java: data.h
	mig -target=telosb -I$TOSDIR/lib/CC2420Radio  -java-classname=dataMsg java data.h data_msg -o $@

dataMsg.class: dataMsg.java
	javac dataMsg.java



entryMsg.java: data.h
	mig -target=telosb -I$TOSDIR/lib/CC2420Radio  -java-classname=entryMsg java data.h entry_msg -o $@

entryMsg.class: entryMsg.java
	javac entryMsg.java



statsMsg.java: data.h
	mig -target=telosb -I$TOSDIR/lib/CC2420Radio  -java-classname=statsMsg java data.h stats_msg -o $@

statsMsg.class: statsMsg.java
	javac statsMsg.java


include $(MAKERULES)




