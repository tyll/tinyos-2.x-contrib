@title README for TestGTS
@author Aitor Hernandez <aitorhh@kth.se>

Description
--------------------------------------------------

In this application one node takes the role of a PAN coordinator in a
beacon-enabled 802.15.4 PAN, it transmits periodic beacons and waits for
incoming DATA frames. A second node acts as a device, it first scans the
pre-defined channel for beacons from the coordinator and once it finds a beacon
it tries to synchronize to and track all future beacons. Then it configures the
GTS slots that it needs, sending the MLME_GTS.request.

The devices send a GTS allocation request for transmission, and if 
TOS_NODE_ID==0x02 the node tries to send a GTS allocation request for
reception as well.
The coordinator is configured to send data packets to NODE_ID=0x02 using GTS.

Once, the devices has the slots allocated, they star sending data packets
to the coordinator using their slots. And the NODE_ID=0x02 will receive packet
in its reception slot.

Criteria for a successful test
--------------------------------------------------

LED2. Coordinator and device should both toggle LED2 in unison, indicating that they
are sending/receiving beacons. 
LED1. They should also toggle LED1 when coordinator receives a packet
(MCPS_DATA.indication) or, in the device side, they toggle LED1 when they send a packet
(MCPS_DATA.confirm)
LED0. This led is blinking in case of failure, or an error in the transmission. 
We fail in case we don't have any slot allocated.

Options
--------------------------------------------------

1. Deallocations
	We have implemented a deallocation mechanism to end the simulation test. And see 
	if the deallocations initiated by the device are working. (See MLME_GTS.confirm())

2. Standard deallocation mechanism
	We have the standard deallocation mechanism initiated by the coordinator disabled.
	In the standard GTS deallocation initiated by the coordinator, it sets the starting
	slot to zero and delete it after aGtsPersistenceTime. To enable it compile with
	CFLAGS += -DTKN154_STD_DEALLOCATION.
	By default we delete the GTS descriptor directly after the deallocation initiate by the
	deallocation.
	
3. GTS request with one queue: CFLAGS += DTKN154_ONE_REQUEST_QUEUE
	By adding this parameter, we switch the queue of the GTS request, to one queue.
	In this case, we don't distinguish between allocation and deallocations request,
	so it will be inefficient depending on the amout of request on the network.
	See GTS implementation Documentation. 

Tools
--------------------------------------------------
None


Usage
--------------------------------------------------

1a. Install the coordinator:

    $ cd coordinator; make <platform> install

1b. Install the coordinator with one queue:

    $ cd coordinatorOneQueue; make <platform> install
	
	the CFLAGS += DTKN154_ONE_REQUEST_QUEUE flag is enabled by default
	in this app

2. Install one or more devices

    $ cd device; make <platform> install,X

    where X is a pre-assigned short address and should be different 
    for every device.

You can change some of the configuration parameters in app_profile.h

Known bugs/limitations
--------------------------------------------------


- Many TinyOS 2 platforms do not have a clock that satisfies the
  precision/accuracy requirements of the IEEE 802.15.4 standard (e.g. 
  62.500 Hz, +-40 ppm in the 2.4 GHz band); in this case the MAC timing 
  is not standard compliant
