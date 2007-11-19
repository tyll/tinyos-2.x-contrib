#include "KeepAlive.h"

configuration KeepAliveC
{
  provides interface KeepAlive;
  uses interface Monitor;
}

implementation
{
  components ActiveMessageC as Radio, DisseminationC,
    new DisseminatorC(nx_struct Beacon, 0x0110) as BeaconDisseminator,
    new TimerMilliC() as TimeoutTimer,
    new TimerMilliC() as BeaconTimer,
    LedsC, NoLedsC,
    KeepAliveP;

  KeepAlive = KeepAliveP;
  Monitor = KeepAliveP;

  KeepAliveP.RadioSplitControl -> Radio;
  KeepAliveP.DisseminationStdControl -> DisseminationC;
  KeepAliveP.BeaconUpdate -> BeaconDisseminator;
  KeepAliveP.BeaconValue -> BeaconDisseminator;  
  KeepAliveP.TimeoutTimer -> TimeoutTimer;
  KeepAliveP.BeaconTimer -> BeaconTimer;
  KeepAliveP.Leds -> LedsC;
}
