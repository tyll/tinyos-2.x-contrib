GEN=TimeSyncPollReply.java Constants.java
PFLAGS += -DTOSH_DATA_LENGTH=103 

APP_H=../TestTimeSyncPollerMsg.h

all: app.jar

app.jar: FTSPDataLogger.class
	jar cf $@ *.class

TimeSyncPollReply.java: $(APP_H)
	mig -target=null -java-classname=TimeSyncPollReply java $(APP_H) TimeSyncPollReply -o $@

Constants.java: $(APP_H)
	ncg -target=null -java-classname=Constants java $(APP_H) TestTimeSyncPollerMsg.h -o $@

FTSPDataLogger.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm app.jar
