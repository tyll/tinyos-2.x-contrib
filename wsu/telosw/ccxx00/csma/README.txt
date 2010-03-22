
Summary: I recommend using the continuoussense CSMA implementation.


The singlesense CSMA is the type of CSMA originally implemented in TinyOS for
radios like the CC1000, CC2420, etc.  At the end of each backoff period, it
samples the channel a single time to determine if it's ok to talk. If the
channel is clear, the talking begins.  The problem is, in some low power 
communications strategies, you might be talking in the middle of another
transmitter's packetized wake-up transmission.

The continuoussense CSMA must see a clear channel throughout an entire backoff
period before sending.  If the channel is ever not clear during a backoff 
period, then the congestion backoffs start over again.  These backoff periods
begin long in duration and gradually get more rapid as the transmitter
becomes more frantic trying to get its message out.  This is a very fair method
of sharing the channel while maintaining compatibility with low power 
communication strategies. 

I also noticed that with a manually duty cycling CC1100 radio waking up in
the middle of another node's transmission, the carrier-sense line and RSSI
will remain high even after the transmitter is gone (and I verified this with
a spectrum analyzer).  This prevents you from transmitting for a *long* time.
The continuous sense implementation takes care of this by kicking the radio
in and out of RX mode between backoffs, but only when a packet is not being
received.

-David Moss

