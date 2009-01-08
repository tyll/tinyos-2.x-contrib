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

#include "Csma.h"
#include "Blaze.h"

/**
 * The CSMA layer sits directly above the asynchronous portion of the
 * transmit branch.  It is responsible for loading the TX FIFO with data
 * to send, then sending the data by either forcing it (no CCA) or using
 * backoffs to avoid collisions.
 *
 * The CSMA interface is provided to determine the properties of CCA
 * and backoff durations.  The use of call-backs is done very deliberately, 
 * described below.
 *
 * If you signal out an *event* to request an initial backoff and
 * several components happen to be listening, then those components
 * would be required to return a backoff value, regardless of whether or not
 * those components are interested in affecting the backoff for the given
 * AM type.  We don't want that behavior.
 * 
 * With a call back strategy, components can listen for the requests and then
 * decide if they want to affect the behavior.  If the component wants to
 * affect the behavior, it calls back using the setXYZBackoff(..) command.
 * If several components call back, then the last component to get its 
 * word in has the final say. 
 * 
 * With a manually duty cycling CC1100 radio waking up in
 * the middle of another node's transmission, the carrier-sense line and RSSI
 * will remain high even after the transmitter is gone (and I verified this with
 * a spectrum analyzer).  This prevents you from transmitting for a *long* time.
 * The continuous sense implementation takes care of this by kicking the radio
 * in and out of RX mode between backoffs, but only when a packet is not being
 * received.
 * 
 * @author David Moss
 */
configuration CsmaC {
  provides {
    interface Send[radio_id_t radioId];
    interface Csma[am_id_t amId];
    interface Backoff as InitialBackoff[am_id_t amId];
    interface Backoff as CongestionBackoff[am_id_t amId];
    interface SplitControl[radio_id_t radioId];
  }
}

implementation {
  
  components CsmaP;
  Send = CsmaP;
  Csma = CsmaP;
  InitialBackoff = CsmaP.InitialBackoff;
  CongestionBackoff = CsmaP.CongestionBackoff;
  SplitControl = CsmaP;
  
  components new BlazeSpiResourceC();
  CsmaP.Resource -> BlazeSpiResourceC;
  
  components BlazeCentralWiringC;
  CsmaP.BlazeRegSettings -> BlazeCentralWiringC;
  CsmaP.Csn -> BlazeCentralWiringC.Csn;
  CsmaP.EnergyIo -> BlazeCentralWiringC.Gdo2_io;
  CsmaP.EnergyInterrupt -> BlazeCentralWiringC.Gdo2_int;
  CsmaP.RxInterrupt -> BlazeCentralWiringC.Gdo0_int;
  
  components BlazeSpiC;
  CsmaP.PaReg -> BlazeSpiC.PA;
  CsmaP.IOCFG2 -> BlazeSpiC.IOCFG2;
  CsmaP.MCSM1 -> BlazeSpiC.MCSM1;
  CsmaP.PKTSTATUS -> BlazeSpiC.PKTSTATUS;
  CsmaP.SIDLE -> BlazeSpiC.SIDLE;
  
  components BlazeTransmitC;
  CsmaP.AsyncSend -> BlazeTransmitC.AsyncSend;
  
  components new ReceiveModeC();
  CsmaP.ReceiveMode -> ReceiveModeC;
  
  components BlazePacketC;
  CsmaP.BlazePacketBody -> BlazePacketC;
  CsmaP.BlazePacket -> BlazePacketC;
  
  components new StateC();
  CsmaP.State -> StateC;
  
  components new AlarmMultiplexC();
  CsmaP.BackoffTimer -> AlarmMultiplexC;
  
  components RandomC;
  CsmaP.Random -> RandomC;
  
  components LedsC;
  CsmaP.Leds -> LedsC;
    
}
