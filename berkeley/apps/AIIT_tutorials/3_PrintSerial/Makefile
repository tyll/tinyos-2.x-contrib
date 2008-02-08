COMPONENT=PrintSerialAppC
BUILD_EXTRA_DEPS += PrintSerial.class
CLEAN_EXTRA = *.class PrintSerialMsg.java

PrintSerial.class: $(wildcard *.java) PrintSerialMsg.java
	javac *.java

PrintSerialMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=PrintSerialMsg PrintSerial.h print_serial_msg -o $@


include $(MAKERULES)

