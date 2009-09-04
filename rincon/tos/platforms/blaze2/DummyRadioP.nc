
#include "AM.h"
#include "message.h"
#include "Blaze.h"

generic module DummyRadioP() {
  provides {
    interface SplitControl;
    interface SplitControl as BlazeSplitControl[radio_id_t radioId];
    interface Send;
    interface AMSend[am_id_t amId];
  }
}

implementation {


  blaze_metadata_t *getMetadata( message_t *msg ) {
    return (blaze_metadata_t *) msg->metadata;
  }
  
  
  command error_t SplitControl.start() {
    signal SplitControl.startDone(SUCCESS);
    return SUCCESS;
  }
  
  command error_t SplitControl.stop() {
    signal SplitControl.stopDone(SUCCESS);
    return SUCCESS;
  }
  
  
  command error_t BlazeSplitControl.start[radio_id_t radioId]() {
    signal BlazeSplitControl.startDone[radioId](SUCCESS);
    return SUCCESS;
  }
  
  command error_t BlazeSplitControl.stop[radio_id_t radioId]() {
    signal BlazeSplitControl.stopDone[radioId](SUCCESS);
    return SUCCESS;
  }
  
  
  /******************* Send ****************/
  command error_t Send.send(message_t *msg, uint8_t len) {
    (getMetadata(msg))->ack = TRUE;
    signal Send.sendDone(msg, SUCCESS);
    return SUCCESS;
  }
  
  command error_t Send.cancel(message_t* msg) {
    signal Send.sendDone(msg, ECANCEL);
    return SUCCESS;
  }
  
  command uint8_t Send.maxPayloadLength() {
    return TOSH_DATA_LENGTH;
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return msg->data;
  }
  
  
  /***************** AMSend ****************/
  command error_t AMSend.send[am_id_t amId](am_addr_t dest, message_t *msg, uint8_t len) {
    (getMetadata(msg))->ack = TRUE;
    signal AMSend.sendDone[amId](msg, SUCCESS);
    return SUCCESS;
  }
  
  command error_t AMSend.cancel[am_id_t amId](message_t* msg) {
    signal AMSend.sendDone[amId](msg, ECANCEL);
    return SUCCESS;
  }
  
  command uint8_t AMSend.maxPayloadLength[am_id_t amId]() {
    return TOSH_DATA_LENGTH;
  }

  command void *AMSend.getPayload[am_id_t amId](message_t* msg, uint8_t len) {
    return msg->data;
  }
  
  /***************** Defaults ****************/
  default event void Send.sendDone(message_t *msg, error_t error) {}
  default event void AMSend.sendDone[am_id_t amId](message_t *msg, error_t error) {}
  default event void SplitControl.startDone(error_t error) {}
  default event void SplitControl.stopDone(error_t error){}
  default event void BlazeSplitControl.startDone[radio_id_t radioId](error_t error) {}
  default event void BlazeSplitControl.stopDone[radio_id_t radioId](error_t error) {}
  
}

