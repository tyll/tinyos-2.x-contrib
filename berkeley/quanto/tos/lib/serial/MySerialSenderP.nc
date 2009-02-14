//$Id$

/* "Copyright (c) 2000-2005 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * This component provides functionality to send many different kinds
 * of serial packets on top of a general packet sending component. It
 * achieves this by knowing where the different packets in a my_message_t
 * exist through the SerialPacketInfo interface.
 *
 * @author Philip Levis
 * @author Ben Greenstein
 * @date August 7 2005
 *
 */

/* Based on the send path of SerialDispatcherP */

module MySerialSenderP {
  provides {
    interface MySend;
  }
  uses {
    interface SendBytePacket;
    interface ReceiveBytePacket;
    interface Leds;
  }
}
implementation {

  typedef enum {
    SEND_STATE_IDLE = 0,
    SEND_STATE_BEGIN = 1,
    SEND_STATE_DATA = 2
  } send_state_t;

  /* This component provides double buffering. */
  my_message_t messages[2];     // buffer allocation
  my_message_t* messagePtrs[2] = { &messages[0], &messages[1]};
  
  // We store a separate receiveBuffer variable because indexing
  // into a pointer array can be costly, and handling interrupts
  // is time critical.

  uint8_t *sendBuffer = NULL;
  send_state_t sendState = SEND_STATE_IDLE;
  uint8_t sendLen = 0;
  uint8_t sendIndex = 0;
  norace error_t sendError = SUCCESS;
  bool sendCancelled = FALSE;


  command error_t MySend.send(my_message_t* msg, uint8_t len) {
    uint8_t b;
    if (sendState != SEND_STATE_IDLE) {
      return EBUSY;
    }

    atomic {
      
      sendError = SUCCESS;
      sendBuffer = (uint8_t*)msg;
      sendState = SEND_STATE_DATA;
      sendCancelled = FALSE;
      // If something we're starting past the header, something is wrong
      // Bug fix from John Regehr


      sendLen = len;
      b = sendBuffer[0];
      sendIndex = 1; //we send the first byte here
    }
    if (call SendBytePacket.startSend(b) == SUCCESS) {
      return SUCCESS;
    }
    else {
      sendState = SEND_STATE_IDLE;
      return FAIL;
    }
  }

  command uint8_t MySend.maxPayloadLength() {
    return (sizeof(my_message_t));
  }

  command void* MySend.getPayload(my_message_t* m, uint8_t len) {
    if (len > sizeof(my_message_t)) {
      return NULL;
    }
    else {
      return m;
    }
  }

    
  task void signalSendDone(){
    error_t error;

    sendState = SEND_STATE_IDLE;
    atomic error = sendError;

    if (sendCancelled) error = ECANCEL;
    signal MySend.sendDone((my_message_t *)sendBuffer, error);
  }

  command error_t MySend.cancel(my_message_t *msg){
    if (sendState == SEND_STATE_DATA && sendBuffer == ((uint8_t *)msg)) {
      call SendBytePacket.completeSend();
      sendCancelled = TRUE;
      return SUCCESS;
    }
    return FAIL;
  }

  async event uint8_t SendBytePacket.nextByte() {
    uint8_t b;
    uint8_t indx;
    atomic {
      b = sendBuffer[sendIndex];
      sendIndex++;
      indx = sendIndex;
    }
    if (indx > sendLen) {
      call SendBytePacket.completeSend();
      return 0;
    }
    else {
      return b;
    }
  }
  async event void SendBytePacket.sendCompleted(error_t error){
    atomic sendError = error;
    post signalSendDone();
  }

 
  async event error_t ReceiveBytePacket.startPacket() {
    return FAIL;
  };
  async event void ReceiveBytePacket.byteReceived(uint8_t data) {
  };
  async event void ReceiveBytePacket.endPacket(error_t result) {
  };

  default event void MySend.sendDone(my_message_t *msg, error_t error){
    return;
  }

  
}
