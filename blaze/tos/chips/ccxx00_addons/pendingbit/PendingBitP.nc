
/**
 * @author David Moss
 */
 
module PendingBitP {
  provides {
    interface PendingBit;
  }

  uses {
    interface Receive[am_id_t amId];
    interface LowPowerListening;
    interface BlazePacket;
    interface Timer<TMilli>;
  }
}

implementation {

  uint16_t normalLocalWakeupInterval;
  
  uint16_t abnormalDuration = 10240U;
  
  uint16_t abnormalWakeupInterval = 0;
  
  /***************** PendingBit Commands ****************/
  command void PendingBit.setDuration(uint16_t bms) {
    abnormalDuration = bms;
  }
  
  command void PendingBit.setLocalWakeupInterval(uint16_t bms) {
    abnormalWakeupInterval = bms;
  }
  
  command void PendingBit.forcePendingBitMode() {
    if(!call Timer.isRunning()) {
      normalLocalWakeupInterval = call LowPowerListening.getLocalWakeupInterval();
      call LowPowerListening.setLocalWakeupInterval(abnormalWakeupInterval);
    }
    
    call Timer.startOneShot(abnormalDuration);
  }
  
  /***************** Receive Events *****************/
  event message_t *Receive.receive[am_id_t amId](message_t *msg, void *payload, uint8_t length) {
    if(call BlazePacket.isPacketPending(msg)) {
      call PendingBit.forcePendingBitMode();
    }
    
    return msg;
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    if(call LowPowerListening.getLocalWakeupInterval() == abnormalWakeupInterval) {
      call LowPowerListening.setLocalWakeupInterval(normalLocalWakeupInterval);
    }
  }
  
}
