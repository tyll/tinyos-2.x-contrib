/**
 * TestGtsAppC.nc  
 *  
 * <br /> KTH | Royal Institute of Technology
 * <br /> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @modified 2010/07/30 
 */

#include "app_profile.h"
configuration TestGtsAppC
{
} implementation {
  components MainC, LedsC, Ieee802154BeaconEnabledC as MAC,
			  new TimerMilliC() as Timer;


  components TestCoordReceiverC as App;
  App.MLME_START -> MAC;
  App.MCPS_DATA -> MAC;
  App.Frame -> MAC;

  MainC.Boot <- App;
  App.Leds -> LedsC;
  App.MLME_RESET -> MAC;
  App.MLME_SET -> MAC;
  App.MLME_GET -> MAC;
  App.MLME_GTS -> MAC;

  App.SendTimer -> Timer;
  App.Packet -> MAC;

  App.IEEE154TxBeaconPayload -> MAC;
}
