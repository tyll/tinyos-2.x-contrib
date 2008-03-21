GEN=TimeSyncPollReport.java TimeSyncPoll.java Constants.java
PFLAGS += -DTOSH_DATA_LENGTH=103 

APP_H=../TestTimeSyncMessage.h

all: app.jar

app.jar: DataLogger.class
	jar cf $@ *.class

TimeSyncPollReport.java: $(APP_H)
	mig -target=null -java-classname=TimeSyncPollReport java $(APP_H) TimeSyncPollReport -o $@

TimeSyncPoll.java: $(APP_H)
	mig -target=null -java-classname=TimeSyncPoll java $(APP_H) TimeSyncPoll -o $@

Constants.java: $(APP_H)
	ncg -target=null -java-classname=Constants java $(APP_H) TestTimeSyncMessage.h -o $@

DataLogger.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm app.jar
