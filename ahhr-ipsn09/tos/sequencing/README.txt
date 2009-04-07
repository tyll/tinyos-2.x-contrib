README for SEQUENCING
Author: Konrad Iwanicki <iwanicki@few.vu.nl>

Description:

The sequencing functionality is a functionality that is commonly used
by networking protocols. It allows for assigning a sequence number to
each packet. Sequence numbers are important for instance for link
estimation, where we want to know how many packets we missed, or for
clock synchronization, where we want to corelate link-layer packet time
stamps with the packets.

Tools:

None.

Known bugs/limitations:

The logs are for some previous version of the sequencing functionality,
which also contained management of the global epoch number.

$Id$

