README for APPLICATION
Author: Konrad Iwanicki <iwanicki@few.vu.nl>

Description:

This directory contains a sample application demonstrating the hierarchical
point-to-point routing framework.
  The application maintains a cluster hierarchy with one of the three
available methods. Periodically, each mote reports statistics on the
neighborhood, hierarchy, and maintenance traffic to the PC to which it is
connected. Moreover, one can send a request for a particular mote to
route to any other mote. When performing such routing, the application
running at each mote that forwards a message reports the message reception
and the next routing hop back to the PC. The LEDs of a mote, interpreted
as a number in the TinyOS Leds.get/.set methods, indicate the level of the
mote as a landmark. Moreover, when the LEDs are blinking, it means that the
mote received a routing message which it either has to forward or accept
locally as the destination of the message.
  The application can be interacted with through a separate user interface
(see the Tools section).

Tools:

There are actually many tools for this application. They are located
in the tools directory. This directory should soon be available for
download from the framework website.
1. start-mote-proxy.sh
   A script that starts a mote proxy. The mote proxy provides an interface
   between a mote connected to a PC and the PC. The proxy can receive
   messages sent from the mote and can transmit messages from the PC to
   the mote. The type and format of such messages is defined by this
   application.
2. start-real-router.sh/start-gui-client.bat
   Starts a router to which mote proxies and clients can connect.
   By connecting to a router, a mote proxy may for instance report
   statistics to multiple clients on different PCs in the network as well
   as receive requests from such clients.
3. start-gui-client.sh/start-gui-client.bat
   Starts a nice user interface that allows for visualizing the sensor
   network. It displays the hierarchy and internode connectivity and enables
   interactively browsing the state of the motes. Moreover, the client
   allows for issuing routing requests to the motes and visualizes how such
   requests flow through the network.

Known bugs/limitations:

The application has been tested only on TelosB motes, each of which was
connected to a PC. Therefore, it is not known whether the application
actually runs on different hardware platforms.

$Id$

