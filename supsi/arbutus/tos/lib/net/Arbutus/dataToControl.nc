

#include <AM.h>
#include <Collection.h>
   
interface dataToControl {


  command uint8_t       get_hopcount ();
command uint8_t       get_adjustedHopcount ();
  command void triggerRouteUpdate();
  command void triggerImmediateRouteUpdate();
  command am_addr_t getFormerParent();
 command void attemptParentChange(bool forceChange);
 
  
         command uint16_t getRxControl();
     command uint16_t getTxControl();

  command bool getControlState();

  event void routeStuck();
}
