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
 * BMAC transmission implementation
 * This transmits a long preamble followed by the packet.  To use this on
 * the MSP430, DMA MUST be enabled. Also, it is highly recommended the SMCLK
 * used for SPI is increased above its default minimum.  The microcontroller
 * must access the SPI bus at a minimum of 500 kbps or the node will lock up.
 * 
 * Directly send a message over the radio.  No clear channel assessments are
 * performed.  This is the lowest level.
 *
 * The parameterized ID is, of course, a unique value of UQ_BLAZE_RADIO
 * which you'll find in each individual radio's header file (CC1100.h or 
 * CC2500.h).  
 *
 * @author Jared Hill
 * @author David Moss
 */

#include "IEEE802154.h"
#include "Blaze.h"

configuration BmacTransmitC {

  provides {
    interface AsyncSend[ radio_id_t id ];
  }
}

implementation {

  components BmacTransmitP;
  AsyncSend = BmacTransmitP;
  
  components BlazeCentralWiringC;  
  BmacTransmitP.Csn -> BlazeCentralWiringC.Csn;
  
  components BlazeSpiC as Spi;
  BmacTransmitP.RadioStatus -> Spi.RadioStatus;
  
  BmacTransmitP.SNOP -> Spi.SNOP;
  BmacTransmitP.STX -> Spi.STX;
  BmacTransmitP.SFTX -> Spi.SFTX;
  BmacTransmitP.SFRX -> Spi.SFRX;
  BmacTransmitP.TXFIFO -> Spi.TXFIFO;
  BmacTransmitP.SIDLE -> Spi.SIDLE;
  BmacTransmitP.SRX -> Spi.SRX;
  BmacTransmitP.TxReg -> Spi.TXREG;
  
  components new TimerMilliC();
  BmacTransmitP.Timer -> TimerMilliC;
  
  components new StateC();
  BmacTransmitP.State -> StateC;
  
  components BlazePacketC;
  BmacTransmitP.BlazePacketBody -> BlazePacketC;
  
  components LedsC;
  BmacTransmitP.Leds -> LedsC;
  
}
