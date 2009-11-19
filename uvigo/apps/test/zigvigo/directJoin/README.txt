README for directJoin

Description:

In this application one node takes the role of ZigBee coordinator. As soon as it
is active it resets the ZigBee network layer and it tries to create a new
network in the 26th channel (2480 MHz). After that it will try to join directly
a router with 0x1122334455667788 as IEEE extended address.

A second node acts as ZigBee router; it resets its network layer and it will try
to join to the network using RejoinNetwork == 0x01 (direct join).

Meaning of the LEDs:
COORDINATOR:
(RED)     LED0 ON  => NLME_DIRECT_JOIN.confirm [Status == NWK_SUCCESS]
(GREEN)   LED1 ON  => NLME_JOIN.indication

ROUTER
(RED)     LED0 ON  => NLME_JOIN.confirm  [Status == NWK_SUCCESS]

Usage:

1. Install the coordinator:

    $ cd coordinator; make <platform> install

2. Install the router:

    $ cd router; make <platform> install
