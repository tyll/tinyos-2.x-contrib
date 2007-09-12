
/**
 * Asynchronous acknowledgement receive interface.
 * @author David Moss
 */

#include "Blaze.h"

interface AckReceive {

  async event void receive( am_addr_t source, am_addr_t destination, uint8_t dsn );
  
}

