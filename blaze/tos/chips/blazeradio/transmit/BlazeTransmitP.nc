

/**
 * @author Jared Hill
 */
 
/**
 * This Module assumes it already has control of the Spi Bus when called
 * It also assumes the radio is on and configured properly
 */
 
#include "IEEE802154.h"
#include "Blaze.h"
#include "CC1100.h"
#include "AM.h"

module BlazeTransmitP {

  provides {
    interface AsyncSend[ radio_id_t id ];
    interface AsyncSend as AckSend[ radio_id_t id ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
    interface BlazePacketBody;
   
    interface BlazeFifo as TXFIFO;
  
    interface BlazeStrobe as SNOP;
    interface BlazeStrobe as STX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SRX;
  
    interface BlazeRegister as TxReg;
  
    interface CheckRadio;
    interface RadioStatus;
    
    interface State;

    interface Leds;
  }
}

  
implementation {

  enum {
    S_IDLE,
    S_TX_PACKET,
    S_TX_ACK,
  };
  
  /***************** Global Variables ****************/
  uint8_t m_id;
  bool m_sending;
  
  /***************** Local Functions ****************/
  error_t transmit(uint8_t id, void *msg);

  /***************** AsyncSend Commands ****************/
  /**
   * Transmit a regular packet through the given parameterized radio id
   */
  async command error_t AsyncSend.send[ radio_id_t id ](void *msg) {
  
    if(call State.requestState(S_TX_PACKET) != SUCCESS) {
      return FAIL;
    }
    
    return transmit(id, msg);
  }
  
  /***************** AsyncSend Commands ****************/
  /**
   * Only used to transmit acknowledgements
   */
  async command error_t AckSend.send[ radio_id_t id ](void *msg) {
    if(call State.requestState(S_TX_ACK) != SUCCESS) {
      return FAIL;
    }
    
    return transmit(id, msg);
  }
  
  /***************** TXFIFO Events ****************/
  async event void TXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len,
                                     error_t error ) {
    
    uint8_t id;
    uint8_t state;
    
    atomic{
      id = m_id;
    }
    
    // Done writing to the TXFIFO:
    call Csn.set[ id ]();   
    call Csn.clr[ id ]();
    
    // Rx mode by default:
    call SRX.strobe();
    call Csn.set[ id ]();
    
    state = call State.getState();
    call State.toIdle();
    
    if(state == S_TX_PACKET) {
      signal AsyncSend.sendDone[ id ](tx_buf, error);
    
    } else if(state == S_TX_ACK) {
      signal AckSend.sendDone[ id ](tx_buf, error);
    }
  }

  async event void TXFIFO.readDone( uint8_t* tx_buf, uint8_t tx_len, 
      error_t error ) {
  }
  
  
  /***************** Local Functions ****************/
  /**
   * Transmit the given message through the given radio ID
   * @param id the radio id
   * @param msg the message to send, no modifications required.
   */
  error_t transmit(uint8_t id, void *msg) {
    atomic {
      m_id = id;
    }
    
    /* 
     * The length byte in the packet is already correct - it represents the
     * number of bytes in the packet *AFTER* the length byte.
     *
     * So in order to also get that length byte transmitted (or the LSB of the
     * CRC, whichever way you look at it) we gotta add one byte to the transmit
     * length.
     */

    call Csn.clr[ id ]();
    
    if (call RadioStatus.getRadioStatus() == BLAZE_S_RXFIFO_OVERFLOW) {
      call SFRX.strobe();
    }
    
    if (call RadioStatus.getRadioStatus() == BLAZE_S_TXFIFO_UNDERFLOW) {
      call SFTX.strobe();
    }
    
    call STX.strobe();
    while (call RadioStatus.getRadioStatus() != BLAZE_S_TX) {
      // need to keep strobing in case the first one didn't work due to cca problems
      call STX.strobe();
    }
    
    call TXFIFO.write(msg, (call BlazePacketBody.getHeader(msg))->length);
    return SUCCESS;
  }
  
  /***************** Defaults ****************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
  default async event void AsyncSend.sendDone[ radio_id_t id ](void *msg, error_t error) {}
  default async event void AckSend.sendDone[ radio_id_t id ](void *msg, error_t error) {}
  
}


