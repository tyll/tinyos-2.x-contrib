
#include "Boxmac.h"
#include "AM.h"

/** 
 * See the description in the configuration file.
 * @author David Moss
 */
 
module BoxmacP {
  uses {
    interface SendNotifier[am_id_t amId];
    interface LowPowerListening;
    interface Csma[am_id_t amId];
    interface PacketLink;
    interface AMSend[am_id_t amId];
  }
}

implementation {

  /** The packet we're sending */
  norace message_t *myMsg = NULL;
  
  /** TRUE if the initial backoff has already completed */
  norace bool initialBackoffComplete;
  
  /***************** SendNotifier Events ****************/
  event void SendNotifier.aboutToSend[am_id_t amId](am_addr_t dest, message_t *msg) {
    uint16_t sleepInterval;
    initialBackoffComplete = FALSE;

    if((sleepInterval = call LowPowerListening.getRxSleepInterval(msg)) > 0) {
      call LowPowerListening.setRxSleepInterval(msg, (sleepInterval / BOXMAC_WAKEUP_TRANSMISSION_DIVISIONS));
      call PacketLink.setRetries(msg, (call PacketLink.getRetries(msg) + 1) * BOXMAC_WAKEUP_TRANSMISSION_DIVISIONS);
      call PacketLink.setRetryDelay(msg, 0);
      
      myMsg = msg;
    }
  }
  
  /***************** CSMA Events ****************/
  async event void Csma.requestCca[am_id_t amId](message_t *msg) {
    if(msg == myMsg) {
      if(initialBackoffComplete) {
        call Csma.setCca[amId](FALSE);
        return;
      }
      
      initialBackoffComplete = TRUE;
    }
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone[am_id_t amId](message_t *msg, error_t error) {
    if(msg == myMsg) {
      call LowPowerListening.setRxSleepInterval(msg, ((call LowPowerListening.getRxSleepInterval(msg)) * BOXMAC_WAKEUP_TRANSMISSION_DIVISIONS));
      call PacketLink.setRetries(msg, (call PacketLink.getRetries(msg) / BOXMAC_WAKEUP_TRANSMISSION_DIVISIONS) - 1);
      myMsg = NULL;
    }
  }

}
