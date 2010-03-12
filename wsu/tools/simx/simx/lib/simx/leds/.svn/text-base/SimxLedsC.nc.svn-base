#ifndef TOSSIM
#error SimX/Leds is only for use with TOSSIM
#else

#include <stdio.h>

/*
 * Create a component that represents leds in Simx.
 */
configuration SimxLedsC {
  provides interface Leds;
}
implementation {

  components
    SimxLedsP as LedsP,
    SimxPushbackC as Pushback;

  LedsP.Pushback -> Pushback;
  Leds = LedsP;
}

#endif
