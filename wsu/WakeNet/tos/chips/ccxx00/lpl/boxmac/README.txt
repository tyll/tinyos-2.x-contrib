This was designed for real world deployments.

If you are using BMAC, you should consider adding this library in through
your application as well.  It will convert your BMAC wake-up transmission
into a BoX-MAC wake-up transmission, which means lower power.  You're trading
a few dropped packets for a lot of energy savings. Theory of operation is
at the bottom of this readme.

TO USE:
1. Make sure this directory is accessible by your platform. i.e. reference it
   in your .platform file just like every other directory in the radio stack.

2. Make sure you're also using bmac. Boxmac relies on the existence of bmac.

3. Somewhere in your application, make a reference to BoxmacC. It won't include
   itself.
   
4. Wire the radio stack's SendNotifier event to BoxmacC. YES, you must
   do this yourself, because we don't know how your application layer
   is using the SendNotifier interface. If you're using it yourself to 
   modify packets somewhere, you would signal BoxmacC's 
   SendNotifier.aboutToSend() event manually after you have made your own 
   modifications to the outbound packet.
   
5. Compile.


We did some experiments to see how much more efficient this is than straight BMAC.


Experimental Setup:
* 2 nodes, CC1100 radios, one node transmitting and the other receiving

* Random TX packet periods - transmissions not sent on a periodic timer.
  In a sendDone() event, 
    call Timer.startOneShot(50 + (call Random.rand16() % 1024));
  sends the next packet.
  
* Original BMAC wake-up transmission was 1024 bms (local duty cycle = 1024)

Wake-up Divisions | Total Pkts | Tx Duty % | Rx Duty % | Ack Success % | Pkt/Sec
--------------------------------------------------------------------------------
       1 (BMAC)   |    100     |  66.76%   |  35.67%   | 100.0%        | 0.63
       2          |    100     |  64.94%   |  26.80%   | 100.0%        | 0.74
       4          |    100     |  58.41%   |  14.64%   |  94.0%        | 0.80
       8          |    100     |  55.58%   |  8.13%    |  91.0%        | 0.85
       16         |    100     |  58.43%   |  7.74%    |  91.0%        | 0.83
       32         |    100     |  60.30%   |  5.16%    |  91.8%        | 0.78
       64         |    100     |  67.71%   |  2.22%    |  72.0%        | 0.62


From the results above, we see the throughput peaks at 8 wake-up divisions,
which is exactly where the TX duty cycle is at a minimum.  The RX duty cycle
continues to fall off, but 8.13% is already 22.79% less than the original BMAC!
This is a huge increase in savings. We see higher throughput with less energy 
wasted. The penatly is a few 9% more dropped packets, which is tolerable.
The dropped packets are a result of the receiver performing a receive check
in the acknowledgment gap in modulation between packets from the transmitter.

Now the problem is... in a real world application with several nodes around,
you'll have other nodes try to jump in in the middle of another node's
wake-up transmission. To improve delivery success rate, I recommend 4
wake-up divisions at 1024 bms sleep interval. It may vary with different
sleep intervals though.


THEORY OF OPERATION:
BMAC is a long preamble with a little packet at the end. You're wasting time
on air sending useless preamble bytes, which what you really want to be sending
is data.

This layer will modify the operation of BMAC by tapping into other elements
of the radio stack, mainly PacketLink and CSMA.  It will divide up the BMAC 
wake-up preamble into several divisions, and then use PacketLink to transmit 
several smaller BMAC packets.  It taps into the CSMA layer to prevent back-offs 
between subsequent packet transmissions, which increases packet delivery.

The result is a decrease in transmission length because destination receivers
can acknowledge reception in the middle of the wake-up transmission.
This is unlike a standard BMAC packet.  Also, non-destination receivers can
go back to sleep sooner because the wake-up transmission has a destination
address associated with it, whereas a standard BMAC wake-up preamble does not.
Everyone wins.

It's kind of a hybrid between BMAC and XMAC, using a BMAC style extremely 
efficient receive check (single energy check on the channel) and an XMAC style
of packetized delivery, but modified to use a BMAC style longer preamble.

