
/**
 * Select which radio to use for a given message, and parameterize
 * the Send and Receive interfaces below this point by radio id
 * 
 * @author David Moss
 */
 
module RadioSelectP {
  provides {
    interface RadioSelect;
    interface Send;
    interface Receive;
    interface SplitControl[ radio_id_t id ];
    interface Init;
  }
  
  uses {
    interface Send as SubSend[ radio_id_t id ];
    interface Receive as SubReceive[ radio_id_t id ];
    interface SplitControl as SubControl[ radio_id_t id ];
    interface BlazePacketBody;
  }
}

implementation {

  /** State of all our radios - off, on, or sending */
  uint8_t state[uniqueCount(UQ_BLAZE_RADIO)];
  
  /** Current radio ID being turned off */
  uint8_t currentClient;
  
  enum {
    S_OFF = 0,
    S_ON,
    S_SENDING,
  };
  
  /***************** Prototypes ****************/
  task void splitControlStop();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      state[i] = S_OFF;
    }
  }
  
  
  /***************** RadioSelect Commands ****************/
  /**
   * Select the radio to be used to send this message
   * @param msg The message to configure that will be sent in the future
   * @param radioId The radio ID to use when sending this message.
   *    See CC1100.h or CC2500.h for definitions, the ID is either
   *    CC1100_RADIO_ID or CC2500_RADIO_ID.
   * @return SUCCESS if the radio ID was set. EINVAL if you have selected
   *    an invalid radio
   */
  command error_t RadioSelect.selectRadio(message_t *msg, radio_id_t radioId) {
    if(radioId >= uniqueCount(UQ_BLAZE_RADIO)) {
      return EINVAL;
    }
    
    (call BlazePacketBody.getMetadata(msg))->radio = radioId;
    
    return SUCCESS;
    
  }

  /**
   * Get the radio ID this message will use to transmit when it is sent
   * @param msg The message to extract the radio ID from
   * @return The ID of the radio selected for this message
   */
  command radio_id_t RadioSelect.getRadio(message_t *msg) {
    return (call BlazePacketBody.getMetadata(msg))->radio;
  }
  
  
  /***************** Send Commands ****************/
  /**
   * By this point, the length should already be set in the message itself.
   *
   * The RadioSelect.selectRadio() command sets the radio id in the message,
   * and that command filters out invalid radio id's.
   * 
   * @param msg the message to send
   * @param len IGNORED
   * @return SUCCESS if we're going to try to send the message.
   *     FAIL if you need to reevaluate your code
   */
  command error_t Send.send(message_t* msg, uint8_t len) {
    error_t error;
    if(state[call RadioSelect.getRadio(msg)] == S_OFF) {
      return EOFF;
    }
    
    if((error = call SubSend.send[call RadioSelect.getRadio(msg)](msg, len)) == SUCCESS) {
      state[call RadioSelect.getRadio(msg)] = S_SENDING;
    }
    
    return error;
  }

  command error_t Send.cancel(message_t* msg) {
    return call SubSend.cancel[call RadioSelect.getRadio(msg)](msg);
  }

  command uint8_t Send.maxPayloadLength() { 
    return call SubSend.maxPayloadLength[0]();
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload[call RadioSelect.getRadio(msg)](msg, len);
  }

  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start[ radio_id_t id ]() {    
    return call SubControl.start[ id ]();
  }
  
  command error_t SplitControl.stop[ radio_id_t id ]() {
    if(id >= uniqueCount(UQ_BLAZE_RADIO)) {
      return EINVAL;
    }
    
    if(state[id] == S_SENDING) {
      // Queue this up for when this radio is done sending
      currentClient = id;
      post splitControlStop();
      return SUCCESS;
    }
    
    return call SubControl.stop[id]();
  }
  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone[ radio_id_t id ](message_t *msg, error_t error) {
    signal Send.sendDone(msg, error);
  }
  
  /***************** SubReceive Events ****************/
  event message_t *SubReceive.receive[ radio_id_t id ](message_t *msg, void *payload, uint8_t len) {
    (call BlazePacketBody.getMetadata(msg))->radio = id;
    return signal Receive.receive(msg, payload, len);
  }

  /***************** SubControl Events ****************/
  event void SubControl.startDone[ radio_id_t id ](error_t error) {
    state[id] = S_ON;
    signal SplitControl.startDone[id](error);
  }
  
  event void SubControl.stopDone[ radio_id_t id ](error_t error) {
    state[id] = S_OFF;
    signal SplitControl.stopDone[id](error);
  }
  
  /***************** Tasks ****************/
  /**
   * While we're sending, delay the SplitControl stop request
   * Note that the only way we could be sending is if our radio is on,
   * so SubControl.stop must go through.
   */
  task void splitControlStop() {
    if(state[currentClient] == S_SENDING) {
      post splitControlStop();
    
    } else {
      call SubControl.stop[ currentClient ]();
    }
  }
  
  /***************** Defaults ****************/
  default command error_t SubControl.start[ radio_id_t id ]() {
    return EINVAL;
  }
  
  default command error_t SubControl.stop[ radio_id_t id ]() {
    return EINVAL;
  }
  
  default event void SplitControl.startDone[ radio_id_t id ]() {
  }
  
  default event void SplitControl.stopDone[ radio_id_t id ]() {
  }
  
}

