GEN=SniffControlMsg.java SniffRawMsg.java

all: Sniffer802154.jar

Sniffer802154.jar: Sniffer802154.class
	jar cf $@ *.class

SniffControlMsg.java: ../sniff802154.h
	mig -target=null -java-classname=SniffControlMsg java ../sniff802154.h control_pkt_t -o $@

SniffRawMsg.java: ../sniff802154.h
	mig -target=null -java-classname=SniffRawMsg java ../sniff802154.h raw_pkt_t -o $@

Sniffer802154.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm Sniffer802154.jar
