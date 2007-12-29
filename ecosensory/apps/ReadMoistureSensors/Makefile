CFLAGS += -I$(TOSROOT)/../tinyos-2.x-contrib/ecosensory/tos/platforms/ecosens1
CFLAGS += -I$(TOSROOT)/../tinyos-2.x-contrib/ecosensory/tos/sensorboards/a2d12ch
COMPONENT=ReadMoistureSensorsC
SENSORBOARD=a2d12ch

BUILD_EXTRA_DEPS=MoistureSensorsMsg.class
MoistureSensorsMsg.class:  MoistureSensorsMsg.java
	javac MoistureSensorsMsg.java

MoistureSensorsMsg.java:
	mig java -target=null -java-classname=MoistureSensorsMsg ReadMoistureSensors.h MoistureSensorsMsg -o $@
TOSMAKE_PATH += $(TOSROOT)/../tinyos-2.x-contrib/ecosensory/support/make
include $(MAKERULES)
