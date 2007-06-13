/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
 
#include "hardware.h"

configuration PlatformLedsC
{
  provides interface GeneralIO as Led0;
  provides interface GeneralIO as Led1;
  provides interface GeneralIO as Led2;
  uses interface Init;
}

implementation
{
  components PlatformP, GeneralIOC;
  Init = PlatformP.PInit;
  
  // This can be changed (see hardware.h)
  // Each led is mapped to pin 6 of port 1, 2, and 3
  Led0 = GeneralIOC.GeneralIO[DIGIA0];
  Led1 = GeneralIOC.GeneralIO[DIGIB0];
  Led2 = GeneralIOC.GeneralIO[DIGIC0];
}
