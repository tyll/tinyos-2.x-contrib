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

#include "Blaze.h"
#include "BlazeInit.h"
#include "CC2500.h"

/**
 * This configuration is responsible for wiring in the CC2500 pins to the 
 * main BlazeInitC component, and provides register values for the CC2500.
 * 
 * @author Jared Hill
 * @author David Moss
 * @author Roland Hendel
 */

configuration CC2500ControlC {
  provides {
    interface SplitControl;
    interface BlazePower;
    interface BlazeConfig;
  }
}

implementation {
  
  components MainC,
      CC2500ControlP,
      ActiveMessageAddressC,
      HplCC2500PinsC as Pins;
      
  MainC.SoftwareInit -> CC2500ControlP;
  
  BlazeConfig = CC2500ControlP;
  
  CC2500ControlP.Csn -> Pins.Csn;
  CC2500ControlP.Power -> Pins.Power;
  CC2500ControlP.Gdo0_io -> Pins.Gdo0_io;
  CC2500ControlP.Gdo2_io -> Pins.Gdo2_io;
  CC2500ControlP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components BlazeInitC;
  SplitControl = BlazeInitC.SplitControl[ CC2500_RADIO_ID ];
  BlazePower = BlazeInitC.BlazePower[ CC2500_RADIO_ID ];
  BlazeInitC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  BlazeInitC.Power[ CC2500_RADIO_ID ] -> Pins.Power;
  BlazeInitC.BlazeRegSettings[ CC2500_RADIO_ID ] -> CC2500ControlP;
  BlazeInitC.Gdo0_io[ CC2500_RADIO_ID ] -> Pins.Gdo0_io;
  BlazeInitC.Gdo2_io[ CC2500_RADIO_ID ] -> Pins.Gdo2_io;
  BlazeInitC.Gdo0_int[ CC2500_RADIO_ID ] -> Pins.Gdo0_int;
  BlazeInitC.Gdo2_int[ CC2500_RADIO_ID ] -> Pins.Gdo2_int;
  CC2500ControlP.BlazeCommit -> BlazeInitC.BlazeCommit[ CC2500_RADIO_ID ];
  
  components BlazeTransmitC;
  BlazeTransmitC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  BlazeTransmitC.TxInterrupt[ CC2500_RADIO_ID ] -> Pins.Gdo2_int;
  
  components BlazeReceiveC;
  BlazeReceiveC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  BlazeReceiveC.RxIo[ CC2500_RADIO_ID ] -> Pins.Gdo2_io;
  BlazeReceiveC.RxInterrupt [ CC2500_RADIO_ID ] -> Pins.Gdo2_int;
  BlazeReceiveC.BlazeConfig[ CC2500_RADIO_ID ] -> CC2500ControlP.BlazeConfig;
  
  components LedsC;
  CC2500ControlP.Leds -> LedsC;
  
}

