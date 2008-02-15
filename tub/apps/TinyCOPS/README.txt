README for TinyCOPS app
Author/Contact: Jan Hauer <hauer@tkn.tu-berlin.de>

Description:

This is a simple TinyCOPS demo application. It includes one generic publisher
component that tries to publish notifications in response to any incoming
subscription by simply querying the Attribute Collector for attribute data
corresponding to constraints in the subscription. The publisher component also
understands some basic metadata atributes (RATE, COUNT, REBOOT). Every
application also includes a subscriber component and some gateway code so that
the subscriber component bridges any subscription injected from the serial line
to the sensor network. All incoming notifications are bridged back via serial 
line.  For injecting subscriptions/reading notifications use the java tools
(see below).

This app has been tested successfully on the TelosB platform with T2 CVS
version of Feb.14 2008.


Tools:
Java classes for injecting subscriptions and reading notification are located here:
tinyos-2.x-contrib/tub/support/sdk/java/net/tinyos/tinycops


Known bugs/limitations:

None.


$Id$

