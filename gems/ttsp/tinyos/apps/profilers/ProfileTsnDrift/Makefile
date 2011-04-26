BUILD_EXTRA_DEPS = ProfileTsnDrift.class
CLEAN_EXTRA = *.class ReportMsg.java

ProfileTsnDrift.class: ReportMsg.java ReferenceMsg.java
	javac *.java

ReportMsg.java: ProfileTsnDrift.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=ReportMsg ProfileTsnDrift.h ReportMsg -o $@

ReferenceMsg.java: ProfileTsnDrift.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=ReferenceMsg ../ReferenceBroadcaster/ReferenceBroadcaster.h ReferenceMsg -o $@

COMPONENT=ProfileTsnDriftAppC
#SENSORBOARD=mts300

CFLAGS += -I../ReferenceBroadcaster

include $(TSNMAKERULES)
include $(MAKERULES)
