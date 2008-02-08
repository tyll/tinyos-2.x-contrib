COMPONENT=CountsAppC
BUILD_EXTRA_DEPS += PrintCounterReading.class
CLEAN_EXTRA = *.class PrintCounterReadingMsg.java

PrintCounterReading.class: $(wildcard *.java) PrintCounterReadingMsg.java
	javac *.java

PrintCounterReadingMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=PrintCounterReadingMsg PrintCounterReading.h print_counter_reading_msg -o $@

include $(MAKERULES)

