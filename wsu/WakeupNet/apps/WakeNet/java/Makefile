GEN=Constants.java OctopusSentMsg.java OctopusCollectedMsg.java

OCTOPUS_H=../motes/Octopus.h
OCTOPUS_CONFIG_H=../motes/OctopusConfig.h



all: OctopusGui.class

OctopusCollectedMsg.java: $(OCTOPUS_H)
	mig -target=null -java-classname=OctopusCollectedMsg java $(OCTOPUS_H) octopus_collected_msg -o $@

OctopusSentMsg.java: $(OCTOPUS_H)
	mig -target=null -java-classname=OctopusSentMsg java $(OCTOPUS_H) octopus_sent_msg -o $@

Constants.java: $(OCTOPUS_H)
	ncg -target=null -java-classname=Constants java $(OCTOPUS_H) Octopus.h $(OCTOPUS_CONFIG_H) OctopusConfig.h -o $@

OctopusGui.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

