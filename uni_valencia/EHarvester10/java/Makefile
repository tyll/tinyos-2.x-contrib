GEN=HarvesterMsg.java

all: HarvesterMonitor.jar

HarvesterMonitor.jar: HarvesterMonitor.class
	jar cf $@ *.class

HarvesterMsg.java: ../Harvester.h
	mig -target=telosb -java-classname=HarvesterMsg java ../Harvester.h harvesterSensor -o $@

HarvesterMonitor.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm HarvesterMonitor.jar
