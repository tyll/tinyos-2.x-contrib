Usage of BuilPhoenixSourceThreaded.java and PhoenixSourceThreaded.java
-----------------------------------------------------------------------

These 2 classes subsitute the orignial BuildSource and PhoenixSource from TinyOS.jar.
Given a performance problem where packets where lost by the PhoenixSource class
due to a too frequent packet input rate, PhoenixSourceThreaded gives a 
producer-consumer approach in order to avoid loosing "close in time" packets.

The usage is similar to the old one. Just use BuilPhoenixSourceThreaded where BuildSource
and PhoenixSourceThreaded where PhoenixSource.

The makePhoenix method has now an additional argument called nThreads. It indicates the
number of consumer threads used. One should be enough for the majority of the cases,
 2 or more may produce concurrence problems in your application.

EXAMPLE:
--------

String source = "sf@localhost:9002"; 

//OLD VERSION 		

PhoenixSource phoenix;
		
if (source == null) {
	phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
} else {
	phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
	System.out.println("Connected to :" + source);
}
		

//NEW VERSION

PhoenixSourceThreaded phoenix;
Integer numThreads = 1;
		
if (source == null) {
	phoenix = BuildPhoenixSourceThreaded.makePhoenix(PrintStreamMessenger.err, numThreads);
} else {
	phoenix = BuildPhoenixSourceThreaded.makePhoenix(source, PrintStreamMessenger.err, numThreads);
	System.out.println("Connected to :" + source);
}