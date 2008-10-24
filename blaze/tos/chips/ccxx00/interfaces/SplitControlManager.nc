
/**
 * This interface should be parameterized by radio_id_t in the implementation
 *
 * It allows other areas of the system to see what the current status is of
 * any radio.
 *
 * @author David Moss
 */
 
#include "SplitControlManager.h"
#include "Blaze.h"

interface SplitControlManager {

  /**
   * @return TRUE if the radio is currently enabled
   */
  command bool isOn();
  
  /**
   * @return the state of the radio
   */
  command radio_state_t getState();
  
  
  /**
   * Notification that this radio is undergoing a state change.
   * The state will either be CCXX00_TURNING_ON or CCXX00_TURNING_OFF
   * as defined in SplitControlManager.h
   */
  event void stateChange();
  
}

