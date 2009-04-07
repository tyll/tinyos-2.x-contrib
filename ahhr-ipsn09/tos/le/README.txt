README for LE
Author: Konrad Iwanicki <iwanicki@few.vu.nl>

Description:

The link estimator measures the percentage of packets received from
a node's neighbors and calculates the bidirectional link qualities
to these neighbors. This method for measuring the link quality was
published as: A. Woo, T. Tong, and D. Culler, ``Taming the underlying
challenges of reliable multihop routing in sensor networks,'' in
SenSys'03: Proceedings of the First ACM Int'l Conf. on Embedded Networked
Sensor Systems, Los Angeles, CA, USA, November 2003.
  This implementation differs from the default /lib/net/le TinyOS 2.0.0
implementation (by Omprakash Gnawali) in that it uses a different aging
technique for the neighbor table entries.

Tools:

Known bugs/limitations:

It is crucial to provide appropriate wiring for the final configuration.
The link estimator stamps each packet it sends with a sequence number.
It also expects to receive packets with all sequence numbers from every
neighbor:
1. Every packet delivered to the link estimator is meant for the
   AM_BROADCAST_ADDR, in which case the SubSnoopAndReceive interface can
   be wired to any Receive interface.
2. Packets are destined for particular nodes, in which case
   the SubSnoopAndReceive interface should be wired to both snooping and
   receiving interfaces.
If the wiring is incorrect, the link estimator will have gaps in the
sequence numbers of a node's neighbors, and consequently, the estimated
link qualities will be invalid.
  It is also important to invoke the link quality aging function
periodically. Otherwise, the link qualities will not be updated.

$Id$

