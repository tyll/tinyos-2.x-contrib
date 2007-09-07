
#include "BlazeInit.h"

/**
 * Obtain the default register values for radio initialization
 * @author David Moss
 */

interface BlazeRegSettings {

  command uint8_t *getDefaultRegisters();
  
}

