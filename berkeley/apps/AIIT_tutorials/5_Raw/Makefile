COMPONENT=RawAppC
BUILD_EXTRA_DEPS += PrintReadingArr.class
CLEAN_EXTRA = *.class PrintReadingArrMsg.java

PrintReadingArr.class: $(wildcard *.java) PrintReadingArrMsg.java
	javac *.java

PrintReadingArrMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=PrintReadingArrMsg PrintReadingArr.h print_reading_arr_msg -o $@

include $(MAKERULES)

