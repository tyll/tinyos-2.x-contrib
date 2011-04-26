BUILD_EXTRA_DEPS = TestTtsp.class
CLEAN_EXTRA = *.class TestTtspMsg.java

TestTtsp.class: TestTtspMsg.java
	javac *.java

TestTtspMsg.java: TestTtsp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=TestTtspMsg TestTtsp.h TestTtspMsg -o $@

COMPONENT=TestTtspAppC
BOOTLOADER=tosboot

PFLAGS += -DTTSP_MAX_PRECISION_ERROR=10

CFLAGS += -I../../BeaconBroadcaster
CFLAGS += -I../../../tos/interfaces -I../../../tos/lib -I../../../tos/lib/ttsp
CFLAGS += -I$(TOSDIR)/lib/printf

include $(TSNMAKERULES)
include $(MAKERULES)
