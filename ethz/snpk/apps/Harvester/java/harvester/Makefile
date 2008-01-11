GEN=Constants.java HarvesterMsg.java TreeInfoMsg.java StatusMsg.java

all: HarvesterMonitor.jar

HarvesterMonitor.jar: HarvesterMonitor.class
	jar cf $@ *.class

HarvesterMsg.java: ../../Harvester.h
	mig -target=telosb -java-classname=HarvesterMsg java ../../Harvester.h harvesterSensor -o $@

TreeInfoMsg.java: ../../Harvester.h
	mig -target=null -java-classname=TreeInfoMsg java ../../Harvester.h harvesterTopology -o TreeInfoMsg.java	

StatusMsg.java: ../../Harvester.h
	mig -target=null -java-classname=StatusMsg java ../../Harvester.h harvesterNodeStatus -o StatusMsg.java	

Constants.java: ../../Harvester.h 
	ncg -target=null -java-classname=Constants java ../../Harvester.h NREADINGS DEFAULT_INTERVAL -o $@

HarvesterMonitor.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm HarvesterMonitor.jar
