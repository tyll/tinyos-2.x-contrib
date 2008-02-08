COMPONENT=RequestSampleAppC
BUILD_EXTRA_DEPS += RequestReading.class
CLEAN_EXTRA = *.class RequestReadingMsg.java

RequestReading.class: $(wildcard *.java) RequestReadingMsg.java
	javac *.java

RequestReadingMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=RequestReadingMsg RequestReading.h request_reading_msg -o $@

include $(MAKERULES)

