default: TestWmtpPerformanceReport.class

TestWmtpPerformanceReport.class: TestWmtpPerformanceReport.java EventMsg.java
	javac TestWmtpPerformanceReport.java

EventMsg.java: ../TestWmtp.h
	mig -target=null -java-classname=EventMsg java ../TestWmtp.h EventMsg -o $@

clean:
	rm -f *.class EventMsg.java
