#GEN=Constants.java OctopusSentMsg.java OctopusCollectedMsg.java
# PST-- 10 oct 2008 CVS generates Constants.java wrong (broken mote code?)
GEN=OctopusSentMsg.java OctopusCollectedMsg.java

OCTOPUS_H=../motes/Octopus.h
OCTOPUS_CONFIG_H=../motes/OctopusConfig.h

all: OctopusGui.class

OctopusCollectedMsg.java: $(OCTOPUS_H)
	mig -target=null -java-classname=OctopusCollectedMsg java $(OCTOPUS_H) octopus_collected_msg -o $@

OctopusSentMsg.java: $(OCTOPUS_H)
	mig -target=null -java-classname=OctopusSentMsg java $(OCTOPUS_H) octopus_sent_msg -o $@

Constants.java: $(OCTOPUS_H)
	ncg -target=null -java-classname=Constants java $(OCTOPUS_H) Octopus.h $(OCTOPUS_CONFIG_H) OctopusConfig.h -o $@

# PST - 10 oct 2008 cvs does not build (or cleanup) cvsreader
OctopusGui.class: $(wildcard *.java) $(GEN)
	javac com/csvreader/Csv*.java *.java

clean:
	rm -f *.class $(GEN)
	rm -f com/csvreader/*.class
