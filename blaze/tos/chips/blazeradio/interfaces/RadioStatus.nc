
/**
 * Get the state of the radio hardware
 * @author David Moss
 */
 
#include "Blaze.h"

interface RadioStatus {

  async command blaze_status_t getRadioStatus();
  
}

