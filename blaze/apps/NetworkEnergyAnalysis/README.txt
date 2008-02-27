
This application simulates a network surrounding a Node Under Test (NUT).

  [PC]-[BaseStation id=0] ~~~~> [NUT id=1]
 
Your PC connects directly to the base station node that has ID 0.  You have
a NUT off to the side connected to your energy measurement setup.

Connect to the [id=0] node with a serial forwarder, and then use the
Analysis Java application to emulate a network.

You can set the Wake-on Radio receive check interval, in true milliseconds.
This will apply to all nodes.

You can set the number of nearby network nodes to 0 to turn off the "network".

Here are some examples:

  1. Emulate a network with only the NUT.  Wake-on Radio is doing a receive 
     check once every 100 ms.  The NUT is also transmitting a network beacon
     once every 10 seconds.
     
       java Analysis -wor 100 -int 10240 -nodes 0
       
  2. Emulate a network with 5 network nodes surrounding the NUT. Each node
     in this network is doing Wake-on Radio receive checks once every 250 ms.
     Each node in the network sends out a network beacon once every 10 seconds.
     
       java Analysis -wor 250 -int 10240 -nodes 5
       
  3. Measure the energy consumption of a single node doing receive checks at
     once every 100 ms, without sending any messages.  And it's also not
     receiving any messages.
     
       java Analysis -wor 100 -int 0
       
@author David Moss


