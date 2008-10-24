BoX-MAC-2 uses packetized wake-up transmissions with acknowledgment gaps
in between each packet transmission.  CSMA is cut very short, and once a
transmitted takes control of the channel, other transmitters should yield
to the current transmission.

The receive check side uses an energy-based detect. An alarm is set and
an interrupt is enabled that notifies the microcontroller when a carrier
is sensed on the channel.  If the alarm fires before energy is detected, then
the radio goes back to sleep.  The amount of time the radio must be on to 
perform a receive check is just longer than the acknowledgment wait period. 


TODO
* A receiver node keeps locking up in the presence of a nearby transmitter.
* This needs to be designed to work with multiple nearby transmitters.

