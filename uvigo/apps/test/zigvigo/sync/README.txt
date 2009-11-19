README for sync

Description:

In this application one node takes the role of ZigBee coordinator. As soon as it
is active it resets the ZigBee network layer, then it tries to create a new
network in the 26th channel (2480 MHz) and it activates its radio for accepting
incoming association requests. Finally, the ZigBee coordinator remains awaiting
for incoming association requests.

Once a node tries to join, the coordinator will let it join and it will assign
a new network address to it. After that the coordinator will start to send
packets in an indirect way (when joining to the network the router specifies
CapabilityInformation.ReceiverOnWhenIdle == 0) every second.

A second node acts as ZigBee router with
CapabilityInformation.ReceiverOnWhenIdle == 0; it resets its network layer and
it tries to join to the network with PANId equal to 0xFFEEDDCCBBAA0099LL through
the network procedure (RejoinNetwork = 0x02). Once joined, it will poll the
coordinator every second awaiting new data packets.

Meaning of the LEDs:
COORDINATOR:
(RED)    LED0 ON     => NLME_JOIN.indication
(GREEN)  LED1 TOGGLE => NLDE_DATA.confirm [Status == NWK_SUCCESS]

ROUTER
(RED)    LED0 ON     => NLME_JOIN.confirm [Status == NWK_SUCCESS]
(GREEN)  LED1 TOGGLE => NLDE_DATA.indication
(YELLOW) LED2 TOGGLE => NLME_SYNC.confirm [Status == NWK_SUCCESS]

Usage:

1. Install the coordinator:

    $ cd coordinator; make <platform> install

2. Install the router:

    $ cd router; make <platform> install
