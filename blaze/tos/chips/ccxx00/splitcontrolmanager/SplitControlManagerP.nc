
/**
 * See the documentation in SplitControlManagerC.nc
 * @author David Moss
 */

#include "SplitControlManager.h"
#include "Blaze.h"

module SplitControlManagerP {
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

  /** State of all the radios compiled into our system */
  uint8_t radioState[uniqueCount(UQ_BLAZE_RADIO)];

  /** The radio we're currently servicing */
  uint8_t focusedRadio = 0xFF;
  
  enum {
    NO_FOCUSED_RADIO = 0xFF,
  };
  
  
  /***************** SplitControl Commands ****************/
  /**
   * All radios must be off in order to start up one of the radios
   */
  command error_t SplitControl.start[radio_id_t radioId]() {
  
    if(radioState[radioId] == CCXX00_ON) {
      return EALREADY;
    } else if(radioState[radioId] == CCXX00_TURNING_ON) {
      return SUCCESS;
    } else if(radioState[radioId] == CCXX00_TURNING_OFF) {
      return EBUSY;
    }
    
    if(focusedRadio != NO_FOCUSED_RADIO) {
      // Won't let you turn 2 radios on simultaneously
      return FAIL;
    }
    
    focusedRadio = radioId;
    radioState[focusedRadio] = CCXX00_TURNING_ON;
    
    signal SplitControlManager.stateChange[focusedRadio]();
    return call SubControl.start[radioId]();
  }
  
  /**
   * The radio must be on in order to turn it off.
   */
  command error_t SplitControl.stop[radio_id_t radioId]() {
    if(radioState[radioId] == CCXX00_OFF) {
      return EALREADY;
    } else if(radioState[radioId] == CCXX00_TURNING_ON) {
      return EBUSY;
    } else if(radioState[radioId] == CCXX00_TURNING_OFF) {
      return SUCCESS;
    }
    
    if(focusedRadio != radioId) {
      // You can only turn off the radio that is currently on
      // focusedRadio gets set back to NO_FOCUSED_RADIO on stopDone()
      return FAIL;
    }
   
    radioState[focusedRadio] = CCXX00_TURNING_OFF;
    
    signal SplitControlManager.stateChange[focusedRadio]();
    return call SubControl.stop[radioId]();
  }
  

  /***************** Send Commands ****************/
  command error_t Send.send[radio_id_t radioId](message_t* msg, uint8_t len) {
    if(radioState[radioId] != CCXX00_ON) {
      return EOFF;
    } else {
      return call SubSend.send[radioId](msg, len);
    }
  }

  command error_t Send.cancel[radio_id_t radioId](message_t* msg) {
    if(radioState[radioId] != CCXX00_ON) {
      return EOFF;
    } else {
      return call SubSend.cancel[radioId](msg);
    }
  }
  
  command uint8_t Send.maxPayloadLength[radio_id_t radioId]() {
    return call SubSend.maxPayloadLength[radioId]();
  }

  command void* Send.getPayload[radio_id_t radioId](message_t* msg, uint8_t len) {
    return call SubSend.getPayload[radioId](msg, len);
  }
  
  /***************** SplitControlManager Commands ****************/
  /**
   * @return TRUE if the radio is currently enabled
   */
  command bool SplitControlManager.isOn[radio_id_t radioId]() {
    return (radioState[radioId] == CCXX00_ON);
  }
  
  /**
   * @return the state of the radio
   */
  command radio_state_t SplitControlManager.getState[radio_id_t radioId]() {
    return radioState[radioId];
  }
  

  /***************** SubControl Events ****************/
  event void SubControl.startDone[radio_id_t radioId](error_t error) {
    radioState[radioId] = CCXX00_ON;
    signal SplitControl.startDone[radioId](error);
  }
  
  event void SubControl.stopDone[radio_id_t radioId](error_t error) {
    radioState[radioId] = CCXX00_OFF;
    focusedRadio = NO_FOCUSED_RADIO;
    signal SplitControl.stopDone[radioId](error);
  }
  

  /***************** SubSend Events ****************/
  event void SubSend.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
    signal Send.sendDone[radioId](msg, error);
  }
  
  
  /***************** Defaults ****************/
  default event void SplitControl.startDone[radio_id_t radioId](error_t error) {
  }
  
  default event void SplitControl.stopDone[radio_id_t radioId](error_t error) {
  }
  
  default event void SplitControlManager.stateChange[radio_id_t radioId]() {
  }
  
  default command error_t SubControl.start[radio_id_t radioId]() {
  }
  
  default command error_t SubControl.stop[radio_id_t radioId]() {
  }
  
  default event void Send.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
  }
  
  default command error_t SubSend.send[radio_id_t radioId](message_t* msg, uint8_t len) {
    return EINVAL;
  }

  default command error_t SubSend.cancel[radio_id_t radioId](message_t* msg) {
    return EINVAL;
  }
  
  default command uint8_t SubSend.maxPayloadLength[radio_id_t radioId]() {
    return 0;
  }

  default command void* SubSend.getPayload[radio_id_t radioId](message_t* msg, uint8_t len) { 
    return 0;
  }

}

