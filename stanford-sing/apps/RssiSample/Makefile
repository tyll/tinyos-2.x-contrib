COMPONENT=NoiseAppC

BUILD_EXTRA_DEPS=RssiSample.class
CLEAN_EXTRA = *.class RssiSampleMsg.java

RssiSample.class: $(wildcard *.java) RssiSampleMsg.java
	javac *.java

RssiSampleMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=RssiSampleMsg NoiseSample.h rssi_sample_msg -o $@

include $(MAKERULES)

