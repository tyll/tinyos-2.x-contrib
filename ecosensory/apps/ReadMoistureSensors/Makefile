/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * by John Griessen <john@ecosensory.com>
 * Rev 1.0 14 Dec 2007
 */
COMPONENT=ReadMoistureSensorsC
SENSORBOARD=a2d12ch

BUILD_EXTRA_DEPS=MoistureSensorsMsg.class
MoistureSensorsMsg.class:  MoistureSensorsMsg.java
	javac MoistureSensorsMsg.java

MoistureSensorsMsg.java:
	mig java -target=null -java-classname=MoistureSensorsMsg ReadMoistureSensors.h MoistureSensorsMsg -o $@
CFLAGS += -I$(TOSROOT)/../tinyos-2.x-contrib/ecosensory/tos/sensorboards/a2d12ch
CFLAGS += -I$(TOSROOT)/../tinyos-2.x-contrib/ecosensory/tos/platforms/ecosens1
CFLAGS += -I$(TOSROOT)/../tinyos-2.x-contrib/ecosensory/tos/platforms/ecosens1/chips
CFLAGS += -I$(TOSROOT)/../tinyos-2.x-contrib/ecosensory/tos/platforms/ecosens1/chips/cc2420
TOSMAKE_PATH += $(TOSROOT)/../tinyos-2.x-contrib/ecosensory/support/make
include $(MAKERULES)
