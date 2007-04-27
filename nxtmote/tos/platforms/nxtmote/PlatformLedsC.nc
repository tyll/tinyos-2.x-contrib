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

  Led0 = GeneralIOC.GeneralIO[1];
  Led1 = GeneralIOC.GeneralIO[2];
  Led2 = GeneralIOC.GeneralIO[4];

}
