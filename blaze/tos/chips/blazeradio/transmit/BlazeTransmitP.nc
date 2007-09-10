

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

    interface Leds;
  }
}

  
implementation {

  
  /***************** Global Variables ****************/
  uint8_t m_id;
  bool m_sending;
  
  /***************** Local Functions ****************/
  void initSend();

  /***************** AsyncSend Commands ****************/
  async command error_t AsyncSend.send[ radio_id_t id ](message_t* msg) {
  
    atomic{
      if(m_sending){
        return FAIL;
      }
      m_id = id;
      m_sending = TRUE;
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
    initSend();
    call TXFIFO.write((uint8_t *) msg, (call BlazePacketBody.getHeader(msg))->length);
    return SUCCESS;
  }
  
  
  /***************** TXFIFO Events ****************/
  async event void TXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len,
                                     error_t error ) {
    
    uint8_t id;
    
    atomic{
      m_sending = FALSE;
      id = m_id;
    }
    
    // Done writing to the TXFIFO:
    call Csn.set[ id ]();   
    call Csn.clr[ id ]();
    
    // Rx mode by default:
    call SRX.strobe(); 
    call Csn.set[ id ]();     
    
    signal AsyncSend.sendDone[ id ]((message_t*)tx_buf, error);
  }

  async event void TXFIFO.readDone( uint8_t* tx_buf, uint8_t tx_len, 
      error_t error ) {
  }
  
  
  /***************** Local Functions ****************/
  void initSend(){
    if (call RadioStatus.getRadioStatus() == BLAZE_S_RXFIFO_OVERFLOW){
      call SFRX.strobe();
    }
    
    if (call RadioStatus.getRadioStatus() == BLAZE_S_TXFIFO_UNDERFLOW){
      call SFTX.strobe();
    }
    
    call STX.strobe();
    while (call RadioStatus.getRadioStatus() != BLAZE_S_TX) {
      // need to keep strobing in case the first one didn't work due to cca problems
      call STX.strobe(); 
    }
  }
  
  /***************** Defaults ****************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
  default async event void AsyncSend.sendDone[ radio_id_t id ](message_t* msg, error_t err) {}
  
}


