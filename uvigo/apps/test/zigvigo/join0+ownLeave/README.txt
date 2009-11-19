README for join0+OwnLeave

Description:

In this application one node takes the role of ZigBee coordinator. As soon as it
is active it resets the ZigBee network layer, then it tries to create a new
network in the 26th channel (2480 MHz) and it activates its radio for accepting
incoming association requests.

Once a node tries to join, the coordinator will let it join and it will
allocate a new network address for it.

A second node acts as ZigBee router; it resets its network layer, it scans the
26th channel for active networks in its range and it will try to join to the
network with extended PANId equal to 0xFFEEDDCCBBAA0099 through the MAC
association procedure (RejoinNetwork = 0x00). After that, the router will start
to send packets every second up to a total of nine. Finally, it will notify its
leaving from the network by requesting the network layer its own leave.

Meaning of the LEDs:
COORDINATOR:
(RED)    LED0 ON     => NLME_JOIN.indication
(GREEN)  LED1 TOGGLE => NLDE_DATA.indication
(YELLOW) LED2 ON     => NLME_LEAVE.indication

ROUTER
(RED)    LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]
(GREEN)  LED1 TOGGLE => NLDE_DATA.confirm  [Status == NWK_SUCCESS]
(YELLOW) LED2 ON     => NLME_LEAVE.confirm [Status == NWK_SUCCESS]

Usage:

1. Install the coordinator:

    $ cd coordinator; make <platform> install

2. Install the router:

    $ cd router; make <platform> install
