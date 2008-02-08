COMPONENT=DualAppC
BUILD_EXTRA_DEPS += PrintReading.class
CLEAN_EXTRA = *.class PrintReadingMsg.java

PrintReading.class: $(wildcard *.java) PrintReadingMsg.java
	javac *.java

PrintReadingMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=PrintReadingMsg PrintReading.h print_reading_msg -o $@

include $(MAKERULES)

