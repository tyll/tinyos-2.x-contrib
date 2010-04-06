COMPONENT=SenZipAppC
APPSDIR=$(TOSROOT)/apps/
CFLAGS += -DCC2420_DEF_CHANNEL=24
CFLAGS += -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/le \
          -I$(TOSDIR)/lib/net/senzip_fq \
          -I$(APPSDIR)/Storage

BUILD_EXTRA_DEPS = FixRtMsg.py FixRtMsg.class BaseMsg.py BaseMsg.class

BaseMsg.py: SenZipApp.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=BaseMsg SenZipApp.h base_msg -o $@

BaseMsg.class: BaseMsg.java
	javac BaseMsg.java

BaseMsg.java: SenZipApp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=BaseMsg SenZipApp.h base_msg -o $@

FixRtMsg.py: $(TOSDIR)/lib/net/senzip/FixedRouting.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=FixRtMsg $(TOSDIR)/lib/net/senzip/FixedRouting.h fixrt_msg -o $@

FixRtMsg.class: FixRtMsg.java
	javac FixRtMsg.java

FixRtMsg.java: $(TOSDIR)/lib/net/senzip/FixedRouting.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=FixRtMsg $(TOSDIR)/lib/net/senzip/FixedRouting.h fixrt_msg -o $@

include $(MAKERULES)
