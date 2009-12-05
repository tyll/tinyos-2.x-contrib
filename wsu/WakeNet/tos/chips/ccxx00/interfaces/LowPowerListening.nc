
/**
 * @author David Moss
 * @author Razvan Musaloiu-E.
 */

interface LowPowerListening {

  command void setLocalWakeupInterval(uint16_t intervalMs);
  
  command uint16_t getLocalWakeupInterval();
  
  command void setRemoteWakeupInterval(message_t *msg, uint16_t intervalMs);
  
  command uint16_t getRemoteWakeupInterval(message_t *msg);
  
}

