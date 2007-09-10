
/**
 * Directly send a message over the radio.  No clear channel assessments are
 * performed.  This is the lowest level.
 *
 * The parameterized ID is, of course, a unique value of UQ_BLAZE_RADIO
 * which you'll find in each individual radio's header file (CC1100.h or 
 * CC2500.h).  
 *
 * The Csn line is wired through CCxx00InitC
 *
 * @author Jared Hill
 * @author David Moss
 */

#include "IEEE802154.h"

configuration BlazeTransmitC {

  provides {
    interface AsyncSend[ radio_id_t id ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
  }
}

implementation {

  components BlazeTransmitP;
  AsyncSend = BlazeTransmitP.AsyncSend;
  Csn = BlazeTransmitP.Csn;
  
  components BlazeSpiC as Spi;
  BlazeTransmitP.CheckRadio -> Spi.CheckRadio;
  BlazeTransmitP.RadioStatus -> Spi.RadioStatus;
  
  BlazeTransmitP.SNOP -> Spi.SNOP;
  BlazeTransmitP.STX -> Spi.STX;
  BlazeTransmitP.SFTX -> Spi.SFTX;
  BlazeTransmitP.SFRX -> Spi.SFRX;
  BlazeTransmitP.TXFIFO -> Spi.TXFIFO;
  BlazeTransmitP.SIDLE -> Spi.SIDLE;
  BlazeTransmitP.SRX -> Spi.SRX;
  BlazeTransmitP.TxReg -> Spi.TXREG;
  
  components BlazePacketC;
  BlazeTransmitP.BlazePacketBody -> BlazePacketC;
  
  components LedsC;
  BlazeTransmitP.Leds -> LedsC;
  
}
