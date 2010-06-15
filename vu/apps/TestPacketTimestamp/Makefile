COMPONENT=TestPacketTimestampAppC
BUILD_EXTRA_DEPS = PingMsg.class PongMsg.class TestPacketTimeStamp.class
CLEAN_EXTRA = *.class PongMsg.java PingMsg.java

PingMsg.class: PingMsg.java
	javac PingMsg.java

PongMsg.class: PongMsg.java
	javac PongMsg.java

PingMsg.java: TestPacketTimestamp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=PingMsg TestPacketTimestamp.h ping_msg -o $@

PongMsg.java: TestPacketTimestamp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=PongMsg TestPacketTimestamp.h pong_msg -o $@

TestPacketTimeStamp.class: PongMsg.class PingMsg.class
	javac TestPacketTimeStamp.java

include $(VUMAKERULES)

