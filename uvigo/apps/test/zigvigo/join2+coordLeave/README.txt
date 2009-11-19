README for join2+coordLeave

Description:

In this application one node takes the role of ZigBee coordinator. As soon as it
is active it resets the ZigBee network layer, then it tries to create a new
network in the 26th channel (2480 MHz) and it activates its radio for accepting
incoming association requests.

Once a node tries to join, the coordinator will let it join and it will
allocate a new network address for it. After that the coordinator will start to
send packets every second up to a total of nine. Finally, the coordinator will
send a leave request to the router for leaving the network.

A second node acts as ZigBee router; it resets its network layer, scans the 26th
channel for active networks in its range and it will try to join to the network
with extended PANId equal to 0xFFEEDDCCBBAA0099 through the network procedure
(RejoinNetwork = 0x02).

Meaning of the LEDs:
COORDINATOR:
(RED)    LED0 ON     => NLME_JOIN.indication
(GREEN)  LED1 TOGGLE => NLDE_DATA.confirm  [Status == NWK_SUCCESS]
(YELLOW) LED2 ON     => NLME_LEAVE.confirm [Status == NWK_SUCCESS]

ROUTER
(RED)    LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]
(GREEN)  LED1 TOGGLE => NLDE_DATA.indication
(YELLOW) LED2 ON     => NLME_LEAVE.indication

Usage:

1. Install the coordinator:

    $ cd coordinator; make <platform> install

2. Install the router:

    $ cd router; make <platform> install
