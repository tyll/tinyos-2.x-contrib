
/**
 * The SplitControlManager makes sure we do not try to turn both radios
 * on at the same time, and ensures we aren't trying to Send to a radio
 * that is currently turned off.
 *
 * When a radio is on, its power may be duty cycling underneath via LPL
 * functionality
 *
 * If a SplitControl.stop() command comes in during a Send, the stop()
 * command will proceed into deeper areas of the radio stack where
 * the Transmit branch must abort the send attempt.  No further sends will
 * be allowed until the radio is turned back on by the application layer.
 *
 * The SplitControlManager interface will allow other areas of the system
 * to see if a particular radio is on, off, or in a state of change.
 *
 * @author David Moss
 */
 
#include "SplitControlManager.h"
#include "Blaze.h"
 
configuration SplitControlManagerC {
  provides {
    interface SplitControl[radio_id_t radioId];
    interface Send[radio_id_t radioId];
    interface SplitControlManager[radio_id_t radioId];
  }
  
  uses {
    interface SplitControl as SubControl[radio_id_t radioId];
    interface Send as SubSend[radio_id_t radioId];
  }
}

implementation {
  
  components SplitControlManagerP;
  
  SplitControl = SplitControlManagerP.SplitControl;
  Send = SplitControlManagerP.Send;
  SplitControlManager = SplitControlManagerP;
  
  SubControl = SplitControlManagerP.SubControl;
  SubSend = SplitControlManagerP.SubSend;
  
  components LedsC;
  SplitControlManagerP.Leds -> LedsC;
  
}


