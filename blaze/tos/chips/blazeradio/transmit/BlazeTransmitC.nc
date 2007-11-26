/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

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
    interface AsyncSend as AckSend[ radio_id_t id ];
  }
}

implementation {

  components BlazeTransmitP;
  AsyncSend = BlazeTransmitP.AsyncSend;
  AckSend = BlazeTransmitP.AckSend;
  
  components BlazeCentralWiringC;  
  BlazeTransmitP.Csn -> BlazeCentralWiringC.Csn;
  BlazeTransmitP.TxInterrupt -> BlazeCentralWiringC.Gdo2_int;
    
  components BlazeSpiC as Spi;
  BlazeTransmitP.RadioStatus -> Spi.RadioStatus;
  
  BlazeTransmitP.SNOP -> Spi.SNOP;
  BlazeTransmitP.STX -> Spi.STX;
  BlazeTransmitP.SFTX -> Spi.SFTX;
  BlazeTransmitP.SFRX -> Spi.SFRX;
  BlazeTransmitP.TXFIFO -> Spi.TXFIFO;
  BlazeTransmitP.SIDLE -> Spi.SIDLE;
  BlazeTransmitP.SRX -> Spi.SRX;
  BlazeTransmitP.TxReg -> Spi.TXREG;
  
  components new StateC();
  BlazeTransmitP.State -> StateC;
  
  components BlazePacketC;
  BlazeTransmitP.BlazePacketBody -> BlazePacketC;
  
  components LedsC;
  BlazeTransmitP.Leds -> LedsC;
  
}
