Author: Rodrigo Fonseca (quanto instrumentation only)

This is Blink modified with Quanto tracing.
It demonstrates tracking of activities across timers, tasks, and
LEDs. 

QuantoAppConstants.py overrides the one in
$QUANTO_ROOT/tools/quanto/scripts

See $QUANTO_ROOT/README.txt for more info.

Running:
 1. program a mote
 2. get data out: 
   java net.tinyos.tools.Listen > file
 3. parse the raw log file:
   read_log.py file

   This produces a parsed log: file.parsed, and an time/energy
   summary per distinc power state: file.pwr. 
 4. produce a graph:
    process.pl -f file.parsed

------------------------------
Original README for Blink
Author/Contact: tinyos-help@millennium.berkeley.edu

Description:

Blink is a simple application that blinks the 3 mote LEDs. It tests
that the boot sequence and millisecond timers are working properly.
The three LEDs blink at 1Hz, 2Hz, and 4Hz. Because each is driven by
an independent timer, visual inspection can determine whether there are
bugs in the timer system that are causing drift. Note that this 
method is different than RadioCountToLeds, which fires a single timer
at a steady rate and uses the bottom three bits of a counter to display
on the LEDs.

Tools:

Known bugs/limitations:

None.


$Id$
