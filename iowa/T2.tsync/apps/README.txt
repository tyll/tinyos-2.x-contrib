These are some notes on Iowa Timesync for T2 including
TEP132 and TEP133, as of 10 November 2008.  

Ted Herman <ted-herman@uiowa.edu>

CHANGES TO TinyOS  

Several changes to the current distribution of TinyOS were needed for
this implemention.  

1.  MicaCounter32khz16C.nc added, to provide Counter<T32khz,uint16_t>
    (but this is just a wiring wrapper for CounterOne16C). 

2.  Msp430CounterMicro32C.nc added, but not currently used (maybe used
    in an enhancement to get binary microsecond timing on Telos).

3.  Numerous changes to cc2420 stack, mainly to support <TMicro, uint32_t>
    interfaces;  TEP132 and TEP133 are engineered for T32khz or TMilli 
    timer granularity, but we hope to use microsecond timing where this is
    feasible.  The changes to the cc2420 stack are enabled only if the 
    compilation flag -DSTAMPMICRO is included.  The microsecond timing is
    consistent with TEP132 and TEP133.  However, an additional change 
    is to stamp messages with the MAC/queueing delay rather than the 
    clock of the transmitter.  This is useful for statistics, testing, 
    and keeping all the packet processing within the stack rather than 
    using any hooks to application code. 

UNRESOLVED ISSUES 

Mixed Telos/CC2420 operation hasn't been tested, though we did get this
to work under earlier Tinyos releases.  Skew compensation has been lightly
tested, getting to about 300 microseconds for a 1-minute beacon on Telos
and around 40 microseconds on MicaZ.  With FTSP's linear regression, the
synchonization could be up to 10x better, but we haven't pushed skew 
compensation for rootless timesync.  

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

5.  PowCon --  Enables application-layer power control (ideally, could 
               be combined with LPL for applications that periodically 
	       sleep for very low power, long-life operation).

HOWTO Make & Wiring

The Makefile in this directory has two nonstandard lines, 

  PFLAGS += -DSTAMPMICRO needed for the microsecond clock.

  PFLAGS += -I../IAtsync

       needed because the modules and wiring of the timesync software
       are in the IAtsync directory

  PFLAGS += =I../tos/chips/cc2420 (and related includes)

       needed to get the stack modications for cc2420

  PFLAGS+= -DTRACK

       the TRACK option is needed to enable (i) skew compensation, which
       could increase the clock precision by an order of magnitude; (ii)
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
mica2, and even mica motes.  The T1 version even supported timesync
between telosb and micaz motes.  Also, there was provision for UART 
connection between a mote and basestation (well, actually just using 
the USB).  Currently, only the telosb and micaz version have been tested,
but if you look at the code you will see lots of places with legacy 
micaz/mica2 provisions, and these can be worked on further to get broader
support.
