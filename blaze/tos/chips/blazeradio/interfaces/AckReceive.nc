
/**
 * Asynchronous acknowledgement receive interface.
 * @author David Moss
 */

#include "Blaze.h"

interface AckReceive {

  async event void receive( blaze_ack_t *ack );
  
}

