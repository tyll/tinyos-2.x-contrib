README for coord+Router+Device

Description:

This application tests a second level join to the network, i.e., an end device
joining to a router already joined to the coordinator. The first step is to
install the router application in one node, then a second node will act first
as coordinator for letting the router to join the network and next it will act
as a device trying to associate.

The coordinator starts the network and remains awaiting for new connections.

The router joins to the coordinator and it also remains awaiting for new
connections.

The end device will scan for available networks. It will only receive the
router's beacons (the coordinator has already disappeared) and it will try to
join the network  by means of it.

Meaning of the LEDs:
COORDINATOR:
(RED)    LED0 ON     => NLME_PERMIT_JOINING.confirm [Status == NWK_SUCCESS]
(GREEN)  LED1 ON     => NLDE_JOIN.indication

ROUTER
(RED)    LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]
(GREEN)  LED1 ON     => NLDE_JOIN.indication
(YELLOW) LED2 ON     => NLME_PERMIT_JOINING.confirm [Status == NWK_SUCCESS]

DEVICE
(RED)    LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]


Usage:

1. Install the router:

    $ cd router; make <platform> install

2. Install the coordinator:

    $ cd coordinator; make <platform> install

3. Install the device:

    $ cd device; make <platform> install
