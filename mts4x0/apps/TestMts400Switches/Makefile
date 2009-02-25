COMPONENT=TestMts400SwitchesAppC
#CFLAGS+=-DTOSH_DATA_LENGTH=31 -DPRINTF_BUFFER_SIZE=1024 -g -ggdb -O0 
SENSORBOARD?=mts420ca

CLASSPATH= $(TOSROOT)/support/sdk/java/:.

CFLAGS += -I$(TOSDIR)/lib/printf/2_0_2

BUILD_EXTRA_DEPS += PrintfMsg.class PrintfClient.class
%.class: %.java
	javac $<

PrintfMsg.java: $(TOSDIR)/lib/printf/printf.h
	mig java -target=$(PLATFORM) $(CFLAGS) \
		-java-classname=PrintfMsg \
		$(TOSDIR)/lib/printf/printf.h printf_msg -o $@


include ../Makelocal
include $(MAKERULES)
