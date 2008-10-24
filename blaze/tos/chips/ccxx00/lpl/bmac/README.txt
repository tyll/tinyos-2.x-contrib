BMAC uses a long preamble transmission, with a carrier sense receive check.  

When a carrier is detected using some method, the radio remains awake
for a short time to see if a packet will be received.  If a packet is not 
received within the time frame, another receive check is performed to see if
the channel is still in use.  The radio goes back to sleep when the channel
is not in use, nothing has been received recently, and nothing is being sent.

The advantage over the WoR plug-in is the radio duty cycling is done in 
software, allowing us control over radio power.  The disadvantage is each
receive check uses a bit more energy.  

