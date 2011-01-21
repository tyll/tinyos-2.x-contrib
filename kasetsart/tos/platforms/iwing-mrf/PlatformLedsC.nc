#include "hardware.h"
 
configuration PlatformLedsC {
  provides interface GeneralIO as Led0;
  provides interface GeneralIO as Led1;
  provides interface GeneralIO as Led2;
  uses interface Init;
}
implementation
{
  components HplAtm328GeneralIOC as IO;
  components PlatformP;

  Init = PlatformP.LedsInit;
  Led0 = IO.PortD5;  // Pin D5 = Green LED
  Led1 = IO.PortD6;  // Pin D6 = Yellow LED
  Led2 = IO.PortD7;  // Pin D7 = Red LED
}

