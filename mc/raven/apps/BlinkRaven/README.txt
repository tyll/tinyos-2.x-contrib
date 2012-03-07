README for BlinkRaven
Author/Contact: Martin Cerveny

Description:

BlinkRaven is based on Blink appliacation.
Also it sends last two bytes to hex LCD, lit on Raven symbol
and display "Hello world" on alfanumeric LCD. 
Blink is a simple application that blinks the 3 mote LEDs. It tests
that the boot sequence and millisecond timers are working properly.
The three LEDs blink at 1Hz, 2Hz, and 4Hz. Because each is driven by
an independent timer, visual inspection can determine whether there are
bugs in the timer system that are causing drift. Note that this 
method is different than RadioCountToLeds, which fires a single timer
at a steady rate and uses the bottom three bits of a counter to display
on the LEDs.

Tools:

make raven jtagicemkii install

Known bugs/limitations:

None.

