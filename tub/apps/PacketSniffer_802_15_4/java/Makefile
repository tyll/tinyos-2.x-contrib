GEN=SniffControlMsg.java

all: Sniff802154Control.jar

Sniff802154Control.jar: Sniff802154Control.class
	jar cf $@ *.class

SniffControlMsg.java: ../sniff802154.h
	mig -target=null -java-classname=SniffControlMsg java ../sniff802154.h control_pkt_t -o $@

Sniff802154Control.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm Sniff802154Control.jar
