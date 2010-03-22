WoR is like BMAC, but relies on the radio hardware to perform receive checks.
Receive checks are the most efficient you will achieve with CCxx00 hardware.


Experiments with WoR found a few problems that need further debugging:

1. The range is significantly diminished with WoR receivers.  
  >> Try increasing the length of a receive check through register settings
     to see if that makes a difference
     
2. Lock-ups occurred with multiple CC2500 transmitters to a single CC2500 
   receiver.
  >> Not sure what the problem was.  The radio stack wasn't locking up in a
     while() loop. The logic analyzer indicates the radio went into WoR mode and
     never received another packet.  In fact, this happened multiple times, 
     so I added a kick timer to periodically kick WoR to make sure
     the radio is doing its job.  If the radio isn't doing its job,
     how is the microcontroller supposed to know to fix it?
     
For these reasons, we are currently switching to some other lpl plug-in
to provide manual radio duty cycling support.  WoR is more efficient, but others
are more reliable.  Reliability wins.

Since we took WoR out of commission, the structure of BlazeC's SplitControl 
has changed. WoR needs to become re-compatible with the inlined SplitControl 
structure to work again.  THIS IS ONLY HERE FOR REFERENCE, NOT TO USE.

