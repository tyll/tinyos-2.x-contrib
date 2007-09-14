
#include "Blaze.h"

/**
 * This layer combines the Send command with the AckReceive event
 * from the asynchronous portion of the receive stack.  It also provides
 * the PacketAcknowledgement interface
 *
 * Above this layer, nothing should be asynchronous context
 * 
 * @author David Moss
 */
configuration AcknowledgementsC {
  provides {
    interface Send[radio_id_t id];
    interface PacketAcknowledgements;
  }
}

implementation {


  /***************** Send Commands ****************/
  
  
  /***************** PacketAcknowledgements Commands ****************/
  /**
   * Tell a protocol that when it sends this packet, it should use synchronous
   * acknowledgments.
   * The acknowledgment is synchronous as the caller can check whether the
   * ack was received through the wasAcked() command as soon as a send operation
   * completes.
   *
   * @param msg - A message which should be acknowledged when transmitted.
   * @return SUCCESS if acknowledgements are enabled, EBUSY
   * if the communication layer cannot enable them at this time, FAIL
   * if it does not support them.
   */
  async command error_t PacketAcknowledgements.requestAck( message_t* msg ) {
  
  }

  /**
   * Tell a protocol that when it sends this packet, it should not use
   * synchronous acknowledgments.
   *
   * @param msg - A message which should not be acknowledged when transmitted.
   * @return SUCCESS if acknowledgements are disabled, EBUSY
   * if the communication layer cannot disable them at this time, FAIL
   * if it cannot support unacknowledged communication.
   */
  async command error_t PacketAcknowledgements.noAck( message_t* msg ) {
  
  }

  /**
   * Tell a caller whether or not a transmitted packet was acknowledged.
   * If acknowledgments on the packet had been disabled through noAck(),
   * then the return value is undefined. If a packet
   * layer does not support acknowledgements, this command must return always
   * return FALSE.
   *
   * @param msg - A transmitted message.
   * @return Whether the packet was acknowledged.
   *
   */
  async command bool PacketAcknowledgements.wasAcked(message_t* msg) {
  
  }
  
}


    