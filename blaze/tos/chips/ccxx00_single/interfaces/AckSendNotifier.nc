
/**
 * @author David Moss
 */
 
#include "Blaze.h"
 
interface AckSendNotifier {

  async event void aboutToSend(blaze_ack_t *ack);

}
