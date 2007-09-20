
/**
 * Select which radio to use for a given message, and parameterize
 * the Send and Receive interfaces below this point by radio id
 * 
 * @author David Moss
 */
 
module RadioSelectP {
  provides {
    interface Send;
    interface Receive;
    interface RadioSelect;
  }
  
  uses {
    interface Send as SubSend[ radio_id_t id ];
    interface Receive as SubReceive[ radio_id_t id ];
    interface BlazePacketBody;
  }
}

implementation {

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
   * @param msg the message to send
   * @param len IGNORED
   * @return SUCCESS if we're going to try to send the message.
   *     FAIL if you need to reevaluate your code
   */
  command error_t Send.send(message_t* msg, uint8_t len) {
    return call SubSend.send[call RadioSelect.getRadio(msg)](msg, len);
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
  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone[ radio_id_t id ](message_t *msg, error_t error) {
    signal Send.sendDone(msg, error);
  }
  
  /***************** SubReceive Events ****************/
  event message_t *SubReceive.receive[ radio_id_t id ](message_t *msg, void *payload, uint8_t len) {
    (call BlazePacketBody.getMetadata(msg))->radio = id;
    return signal Receive.receive(msg, payload, len);
  }

}

