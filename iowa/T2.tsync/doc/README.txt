These are some notes on Iowa Timesync for T2 (3 Nov 07). 
Ted Herman <ted-herman@uiowa.edu>

CHANGES TO TinyOS  

Two changes to the current distribution of TinyOS were needed for
this implemention.  

1.  Added #include <message.h> to RadioTimeStamping.nc

    I didn't see this in the current CVS snapshot either, but found
    it necessary to get things to compile.

2.  Had to add CounterMicro32C.nc for 32-bit microsecond counter support 

    This wiring, a modification of a wiring written by Cory Sharp,
    (not found in T2 distribution) was needed to provide a 32-bit, binary
    microsecond counter.  The fact that it is only wiring indicates that
    the current T2 has the needed code already.  Copyright on the wiring
    is standard UCB copyright, though I got this wiring from Boomerang, 
    then asked Cory for permission (now at Sentilla).

UNRESOLVED ISSUES 

I haven't tested skew compensation yet;  it worked pretty well under
T1, and if it isn't debugged here, that shouldn't be difficult.  Without
skew compensation, the accuracy seems to be around 300 microseconds
(= 10 jiffies using 32KHz counter) for a 1-minute beacon.  With skew
compensation, it might be around 10 times better, or around 1-2 jiffies
(again, using 32KHz counter as base of the clock, since the microsecond
counter just isn't stable enough).  

STYLE BUGS

Several message types in this timesync use float or a special structure
in the field of a message.  However, the platform-neutral "nx_" prefix
doesn't handle these cases, so I skipped "nx_" types, instead using the
native types, and then using "memcpy" to copy local structures to the 
payload -- and this bypasses all concerns of alignment, albeit at some 
memory cost.  

Also, I think some of the components could use "new XXX()" instead of
unique("XXX") in some cases.

HOWTO Usage

The main component is TsyncC, which provides the following interfaces
of interest to the user:

1.  Tsync   -- this has only one event, a signal when timesync has probably
               synchronized with neighboring nodes.  You could use this 
	       even like "Boot.booted()" to kick off your application.

2.  OTime   -- provides all sorts (perhaps too many) of "get clock" 
               methods.  Try reading the interface comments and see if one
	       or other appeals to your application needs.

3.  Neighbor - you don't need to use this one, but there is one method
               "allow(addr)" that you might want to modify if you have
	       an indoor testing environment and would like to make some
	       simple topology control.  See the commented code with 
	       Neighbor.allow in TnbrhoodP.nc for an example of using 
	       allow(addr) to filter timesync messages.  

	       BUT, if you enable a filtering allow() method, then the
	       other methods could be of interest.  Read the somewhat
	       dated document "inaybur.tex" in this directory for the
	       idea of the Neighbor interface.

4.  Wakker  -- this is somewhat like Timer interfaces to set wakeup
               times, but offers the ability to synchronize the wakeup
	       times of multiple nodes, once their clocks are synchronized.
	       (Ooops, this one's not offered by TsyncC, but that shouldn't
	       stop you from using it.)

5.  PowCon --  Not yet tested, but eventually enabled application-layer
               power control (ideally, could be combined with LPL for 
	       applications that periodically sleep for very low power,
	       long-life operation).

HOWTO Make & Wiring

The Makefile in this directory has two nonstandard lines, 

  PFLAGS= -IIAtsync

       needed because the modules and wiring of the timesync software
       are in the IAtsync directory

  PFLAGS+= -DTRACK

       the TRACK option is needed to enable (i) skew compensation, which
       should increase the clock precision by an order of magnitude; (ii)
       to enable efficient, bidirectional topology control in a static 
       network.  If you have mobile nodes, remove the -DTRACK option.  Also,
       some Neighbor functions may not mean much when -DTRACK is removed.

Look at testTsyncC and testTsyncP for a simple example of wiring 
Tsync into an application.  

HOWTO Test

I've copied /opt/tinyos-2.x/support/sdk/c/sf into this directory, so
you can run a lightweight serial forwarder, talking over the USB port
to the Basestation app.  Once sf is running (see runsfb script) you can
snoop on timesync messages to see it working.  The spy program (source
is T2spy.c) will connect to a running sf, and then print any timesync
messages, showing you how well nodes synchronize.  Further, you could also
have one mote running the probeTsync application (make -f Makefile.probe),
which is useful to get a finer look at how well nodes synchronize.  

HOWTO Customize

The header files in IAtsync contain various parameters used in the
implementation, such as how often beacons are sent, the maximum size
of tables (for neighborhood), and so on.  If you're brave, you can 
play around with those.

IMPORTANT TODOs

All of this code was ported from a version working on TinyOS 1, which 
supported several radio stacks, tmote (for Boomerang), telosb, micaz, 
mica2, and even mica motes.  This T1 version even supported timesync
between telosb and micaz motes.  Also, there was provision for UART 
connection between a mote and basestation (well, actually just using 
the USB).  Currently, only the telosb version has been ported to T2,
but if you look at the code you will see lots of places with legacy 
micaz/mica2 provisions, and these can be worked on further to get broader
support.

The Power Control component (PowConC) and its interface haven't been
tested/debugged for T2.  The technique for power control, copied
dumbly from lpl, should be tested.  Also, it would be nice to have 
some way of combining this form of application-layer power control
with lpl.
