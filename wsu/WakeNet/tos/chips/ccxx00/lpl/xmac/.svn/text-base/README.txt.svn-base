XMAC uses packetized wake-up transmissions, and link-layer receive checks.

The receive checks are not intelligent enough to use physical layer information
to turn off the radio quickly if no activity is detected, which makes
the receive checks very inefficient.

XMAC is best used for high throughput networks, with less regard to energy
savings.

The receive checks are the least efficient, consuming more energy than BMAC,
and much more energy than WoR.  The advantage to a packetized wake-up is
the transmitter gets to go back to sleep quickly, which at some point of
throughput, will compensate for the inefficient receive checks.

The difference between this implementation and the actual XMAC paper is the 
lack of a 3-way handshake.  The transmitter doesn't send dummy packets as
a wake-up transmissions; instead, it sends real packets.  This makes the
receive checks a bit less efficient, but spares the double transmission which
may fail.  Ultimately, XMAC is not our preference for this radio,
so we haven't put much work into making it totally efficient.  We simply wanted
it to work reliably in a congested network and offer some amount of
energy savings, and it meets those goals.
