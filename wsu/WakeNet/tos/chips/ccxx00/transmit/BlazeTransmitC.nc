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
 * Transmit large packets (> 64 bytes)
 * To use this on the MSP430, DMA MUST be enabled. Also, it is highly 
 * recommended the SMCLK used for SPI is increased above its default minimum.  
 * The microcontroller must access the SPI bus at a minimum of 500 kbps or the 
 * node will lock up.
 *
 * Point your TransmitArbiterC to the BlazeTransmit instead of BlazeTransmit.
 * This will be a change specific to your workspace until we find this
 * module can work without changes to the TinyOS baseline SPI bus.
 * 
 * This module differs from BlazeTransmit in that packets are not pre-loaded
 * into the radio.  Instead, the radio is kicked into TX mode and then
 * the packet is shot over the SPI bus.  The radio transmits the packet
 * directly as it's coming across the SPI bus, hence the need for at least
 * a 500 kbps SPI bus clock.
 *
 * The parameterized ID is, of course, a unique value of UQ_BLAZE_RADIO
 * which you'll find in each individual radio's header file (CC1100.h or 
 * CC2500.h).  
 *
 * @author Jared Hill
 * @author David Moss
 */

#include "Blaze.h"

configuration BlazeTransmitC {
  provides {
    interface AsyncSend;
    interface AsyncSend as AckSend;
  }
}

implementation {

  components BlazeTransmitP;
  AsyncSend = BlazeTransmitP.AsyncSend;
  AckSend = BlazeTransmitP.AckSend;
    
  components BlazeCentralWiringC;  
  BlazeTransmitP.Csn -> BlazeCentralWiringC.Csn;
  BlazeTransmitP.ChipRdy -> BlazeCentralWiringC.Gdo2_io;
  BlazeTransmitP.RxIo -> BlazeCentralWiringC.Gdo0_io;
  
  components BlazeSpiC as Spi;
  
  BlazeTransmitP.RadioStatus -> Spi.RadioStatus;
  BlazeTransmitP.TXFIFO -> Spi.TXFIFO;
  BlazeTransmitP.STX -> Spi.STX;
  BlazeTransmitP.SFRX -> Spi.SFRX;
    
  components new TimerMilliC();
  BlazeTransmitP.Timer -> TimerMilliC;
  
  components BlazePacketC;
  BlazeTransmitP.BlazePacketBody -> BlazePacketC;
  
  components new ReceiveModeC();
  BlazeTransmitP.ReceiveMode -> ReceiveModeC;
  
  components LedsC;
  BlazeTransmitP.Leds -> LedsC;
    
#if BLAZE_ENABLE_CRC_32
  components PacketCrcC;
  BlazeTransmitP.PacketCrc -> PacketCrcC;
#endif
  
}
