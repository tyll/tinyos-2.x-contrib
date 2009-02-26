COMPONENT=ReliableTestSerialAppC
BUILD_EXTRA_DEPS += ReliableTestSerial.class
CLEAN_EXTRA = *.class ReliableTestSerialMsg.java AckMsg.java ReliableMsg.java RelConstants.java

ReliableTestSerial.class: $(wildcard *.java) ReliableTestSerialMsg.java AckMsg.java ReliableMsg.java RelConstants.java
	javac *.java

ReliableTestSerialMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=ReliableTestSerialMsg ReliableTestSerial.h test_serial_msg -o $@

AckMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=AckMsg reliableserial.h ack_msg -o $@


ReliableMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=ReliableMsg reliableserial.h reliable_msg -o $@

RelConstants.java:
	ncg java -target=null $(CFLAGS) -java-classname=RelConstants reliableserial.h ACK_TIMEOUT -o $@


include $(MAKERULES)

