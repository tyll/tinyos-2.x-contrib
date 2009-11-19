README for edScan

Description:

In this application one node acts as ZigBee end device. As soon as it is active
it will reset the network layer and it will start to do periodic energy scans
(NLME_ED_SCAN) in every channel of the 2.4 GHz band. Once the results are
notified, it uses "printf" for displaying them and then it will start another
scan.

A second node can act as "energy injector" in the 26th channel. It will use the
txThroughput application for continuously send messages to the channel. LED1
will toggle with every sent message.

Meaning of the LEDs:
device:
(RED)     LED0 TOGGLE => NLME_ED_SCAN.confirm

txThroughput:
(GREEN)   LED1 TOGGLE => Packet sent


Usage:

1. Install the device:

    $ cd device; make <platform> install

2. Install the "injector":

    $ cd txThroughput; make <platform> install
