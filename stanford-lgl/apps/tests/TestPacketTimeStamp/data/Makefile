GEN=TimeStampPollReport.java TimeStampPoll.java Constants.java
PFLAGS += -DTOSH_DATA_LENGTH=103 

APP_H=../TestPacketTimeStamp.h

all: app.jar

app.jar: DataLogger.class
	jar cf $@ *.class

TimeStampPollReport.java: $(APP_H)
	mig -target=null -java-classname=TimeStampPollReport java $(APP_H) TimeStampPollReport -o $@

TimeStampPoll.java: $(APP_H)
	mig -target=null -java-classname=TimeStampPoll java $(APP_H) TimeStampPoll -o $@

Constants.java: $(APP_H)
	ncg -target=null -java-classname=Constants java $(APP_H) $(APP_H) -o $@

DataLogger.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN) app.jar

veryclean: clean
	rm app.jar
