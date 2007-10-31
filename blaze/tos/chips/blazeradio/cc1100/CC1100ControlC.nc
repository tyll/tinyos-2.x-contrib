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
#include "CC1100.h"

/**
 * This configuration is responsible for wiring in the CC1100 pins to the 
 * main BlazeInitC component, and provides register values for the CC1100.
 * 
 * @author Jared Hill
 * @author David Moss
 */

configuration CC1100ControlC {
  provides {
    interface SplitControl;
    interface BlazePower;
    interface BlazeConfig;
  }
}

implementation {
  
  components MainC,
      CC1100ControlP,
      ActiveMessageAddressC,
      HplCC1100PinsC as Pins;
      
  MainC.SoftwareInit -> CC1100ControlP;
  
  BlazeConfig = CC1100ControlP;
  
  CC1100ControlP.Csn -> Pins.Csn;
  CC1100ControlP.Power -> Pins.Power;
  CC1100ControlP.Gdo0_io -> Pins.Gdo0_io;
  CC1100ControlP.Gdo2_io -> Pins.Gdo2_io;
  CC1100ControlP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components BlazeInitC;
  SplitControl = BlazeInitC.SplitControl[ CC1100_RADIO_ID ];
  BlazePower = BlazeInitC.BlazePower[ CC1100_RADIO_ID ];
  BlazeInitC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  BlazeInitC.Power[ CC1100_RADIO_ID ] -> Pins.Power;
  BlazeInitC.BlazeRegSettings[ CC1100_RADIO_ID ] -> CC1100ControlP;
  BlazeInitC.Gdo0_io[ CC1100_RADIO_ID ] -> Pins.Gdo0_io;
  BlazeInitC.Gdo2_io[ CC1100_RADIO_ID ] -> Pins.Gdo2_io;
  CC1100ControlP.BlazeCommit -> BlazeInitC.BlazeCommit[ CC1100_RADIO_ID ];
  
  components BlazeTransmitC;
  BlazeTransmitC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  BlazeTransmitC.TxInterrupt[ CC1100_RADIO_ID ] -> Pins.Gdo2_int;
  
  components BlazeReceiveC;
  BlazeReceiveC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  BlazeReceiveC.RxInterrupt [ CC1100_RADIO_ID ] -> Pins.Gdo2_int;
  BlazeReceiveC.BlazeConfig[ CC1100_RADIO_ID ] -> CC1100ControlP.BlazeConfig;
  
  components LedsC;
  CC1100ControlP.Leds -> LedsC;
  
}

