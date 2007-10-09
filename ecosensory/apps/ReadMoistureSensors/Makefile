COMPONENT=ReadMoistureSensorsC
SENSORBOARD=a2d12ch

BUILD_EXTRA_DEPS=MoistureSensorsMsg.class
MoistureSensorsMsg.class:  MoistureSensorsMsg.java
	javac MoistureSensorsMsg.java

MoistureSensorsMsg.java:
	mig java -target=null -java-classname=MoistureSensorsMsg ReadMoistureSensors.h MoistureSensorsMsg -o $@

include $(MAKERULES)
