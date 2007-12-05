
#include "Blaze.h"

module DummyAcknowledgementsP {
  provides {
    interface PacketAcknowledgements;
  }
  
  uses {
    interface Send as SubSend[radio_id_t radioId];
  }
}

implementation {

  /***************** PacketAcknowledgement Commands ****************/
  async command error_t PacketAcknowledgements.requestAck( message_t* msg ) {
    return SUCCESS;
  }

  async command error_t PacketAcknowledgements.noAck( message_t* msg ) {
    return SUCCESS;
  }

  async command bool PacketAcknowledgements.wasAcked(message_t* msg) {
    return FALSE;
  }
  
  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
  }
}
