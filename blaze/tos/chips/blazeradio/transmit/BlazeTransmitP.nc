

/**
 * @author Jared Hill
 */
 
/**
 * This Module assumes it already has control of the Spi Bus when called
 * It also assumes the radio is on and configured properly
 */
 
#include "IEEE802154.h"
#include "Blaze.h"
#include "AM.h"
#include "InterruptState.h"

module BlazeTransmitP {

  provides {
    interface AsyncSend[ radio_id_t id ];
    interface AsyncSend as AckSend[ radio_id_t id ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GpioInterrupt as TxInterrupt[ radio_id_t id ];
    interface BlazePacketBody;
   
    interface BlazeFifo as TXFIFO;
  
    interface BlazeStrobe as SNOP;
    interface BlazeStrobe as STX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SRX;
  
    interface BlazeRegister as TxReg;
    
    interface RadioStatus;
    
    interface State;
    interface State as InterruptState;

    interface Leds;
  }
}

  
implementation {

  enum {
    S_IDLE,
    
    S_LOAD_PACKET,
    S_LOAD_ACK,
    
    S_TX_PACKET,
    S_TX_ACK,
  };
  
  /***************** Global Variables ****************/
  uint8_t m_id;
  bool m_sending;
  
  /***************** Local Functions ****************/
  error_t load(uint8_t id, void *msg);
  error_t transmit(uint8_t id, bool force);

  /***************** AsyncSend Commands ****************/
  /**
   * Load a packet into the TX FIFO
   * @param msg Any type of message where the first byte is the length
   *    of the rest of the bytes in the message not including the length byte
   */
  async command error_t AsyncSend.load[ radio_id_t id ](void *msg) {
    if(call State.requestState(S_LOAD_PACKET) != SUCCESS) {
      return FAIL;
    }
    
    return load(id, msg);
  }
  
  /**
   * Transmit the packet loaded into the TX FIFO.
   * @return SUCCESS if the packet is being sent. 
   *     FAIL if we're doing something else
   *     EBUSY if the channel is busy (when hardware CCA is enabled)
   */
  async command error_t AsyncSend.send[ radio_id_t id ]() {
    
    if(call State.requestState(S_TX_PACKET) != SUCCESS) {
      return FAIL;
    }
    
    return transmit(id, FALSE);
  }
  
  
  /***************** AsyncSend Commands ****************/
  /**
   * Load a packet into the TX FIFO.  Should only be accessed by BlazeReceiveP
   * This will force the packet to go through, even if hardware CCA is enabled.
   * @param msg Any type of message where the first byte is the length
   *    of the rest of the bytes in the message not including the length byte
   */
  async command error_t AckSend.load[ radio_id_t id ](void *msg) {
    if(call State.requestState(S_LOAD_ACK) != SUCCESS) {
      return FAIL;
    }
    
    return load(id, msg);
  }
  
  /**
   * Transmit the acknowledgement already in the TX FIFO.  
   * Should only be accessed by BlazeReceiveP
   */
  async command error_t AckSend.send[ radio_id_t id ]() {
    if(call State.requestState(S_TX_ACK) != SUCCESS) {
      return FAIL;
    }
    
    return transmit(id, TRUE);
  }
  

  
  
  /***************** TXFIFO Events ****************/
  async event void TXFIFO.writeDone( uint8_t* tx_buf, uint8_t tx_len,
                                     error_t error ) {
    
    uint8_t id;
    uint8_t state;
    
    atomic id = m_id;
    
    call Csn.set[ id ]();
    
    state = call State.getState();
    call State.toIdle();
    
    if(state == S_LOAD_PACKET) {
      signal AsyncSend.loadDone[ id ](tx_buf, error);
    
    } else if(state == S_LOAD_ACK) {
      signal AckSend.loadDone[ id ](tx_buf, error);
    }
  }

  async event void TXFIFO.readDone( uint8_t* tx_buf, uint8_t tx_len, 
      error_t error ) {
  }
  
  
  /***************** TxInterrupt Events ****************/
  /**
   * Because we had the falling edge enabled, if this is our event,
   * the packet is finished transmitting. In the future, timestamping can
   * occur on the rising edge.
   */
  async event void TxInterrupt.fired[ radio_id_t id ]() {
    uint8_t state;
    if(call InterruptState.isState(S_INTERRUPT_RX)) {
      return;
    }
    
    

  }
  
  /***************** Local Functions ****************/
  /**
   * Load a message into the TX FIFO
   */
  error_t load(uint8_t id, void *msg) {
    atomic m_id = id;
    
    call Csn.clr[ id ]();
    
    if (call RadioStatus.getRadioStatus() == BLAZE_S_RXFIFO_OVERFLOW) {
      call SFRX.strobe();
    }
    
    if (call RadioStatus.getRadioStatus() == BLAZE_S_TXFIFO_UNDERFLOW) {
      call SFTX.strobe();
    }
    
    call SRX.strobe();
    
    /* 
     * The length byte in the packet is already correct - it represents the
     * number of bytes in the packet *AFTER* the length byte.
     *
     * So in order to also get that length byte transmitted (or the LSB of the
     * CRC, whichever way you look at it) we gotta add one byte to the transmit
     * length.
     */
    
    call TXFIFO.write(msg, (call BlazePacketBody.getHeader(msg))->length + 1);
    return SUCCESS;
  }
  
  
  /**
   * Transmit the given message through the given radio ID
   * @param id the radio id
   * @param force TRUE to force the packet to go through, even if CCA fails the
   *     first few times
   */
  error_t transmit(uint8_t id, bool force) {
    uint8_t state;
    atomic m_id = id;
        
    call Csn.clr[ id ]();
    
    /*
     * Put the radio in RX mode if it's not already. This covers the
     * frequency / synthesizer startup and calibration
     */
    while(call RadioStatus.getRadioStatus() != BLAZE_S_RX) {
      call SFRX.strobe();
      call SRX.strobe();
    }
    
    /*
     * Attempt to transmit.  If the radio goes into TX mode, then our transmit
     * is occurring.  Otherwise, there was something on the channel that
     * prevented CCA from passing
     */
    call TxInterrupt.disable[id]();
    call InterruptState.forceState(S_INTERRUPT_TX);
    call STX.strobe();
    
    if(force) {
      while(call RadioStatus.getRadioStatus() != BLAZE_S_TX) {
        // Keep trying until the channel is clear enough for this to go through
        call STX.strobe();
      }
    
    } else {
      if(call RadioStatus.getRadioStatus() != BLAZE_S_TX) {
        // CCA failed
        call InterruptState.forceState(S_INTERRUPT_RX);
        call TxInterrupt.enableRisingEdge[id]();
        call State.toIdle();
        call Csn.set[ id ]();
        return EBUSY;
      }
    }
    
    while((state = call RadioStatus.getRadioStatus()) != BLAZE_S_RX) {
      if (state == BLAZE_S_RXFIFO_OVERFLOW) {
        call SFRX.strobe();
        call SRX.strobe();
      }
      
      if (state == BLAZE_S_TXFIFO_UNDERFLOW) {
        call SFTX.strobe();
        call SRX.strobe();
      }
    }
    
    call InterruptState.forceState(S_INTERRUPT_RX);
    call TxInterrupt.enableRisingEdge[id]();
    call Csn.set[ id ]();
    
    state = call State.getState();
    call State.toIdle();
    
    if(state == S_TX_PACKET) {
      signal AsyncSend.sendDone[ id ]();
    
    } else if(state == S_TX_ACK) {
      signal AckSend.sendDone[ id ]();
    }
    
    
    // Execution continues at the TxInterrupt event.
    return SUCCESS;
  }
  
  /***************** Defaults ****************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
  default async event void AsyncSend.sendDone[ radio_id_t id ]() {}
  default async event void AsyncSend.loadDone[ radio_id_t id ](void *msg, error_t error) {}
  
  default async event void AckSend.sendDone[ radio_id_t id ]() {}
  default async event void AckSend.loadDone[ radio_id_t id ](void *msg, error_t error) {}
  
  
  default async command error_t TxInterrupt.enableRisingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t TxInterrupt.enableFallingEdge[radio_id_t id]() {
    return FAIL;
  }
  
  default async command error_t TxInterrupt.disable[radio_id_t id]() {
    return FAIL;
  }
  
  
}


