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
 * Collect all GPIO and interrupts from any compiled-in radios and provide
 * them here.
 *  
 *          [ CC2500 ]      [ CC1100 ]
 *            ||||||          ||||||
 *            vvvvvv          vvvvvv
 *         [ CENTRAL WIRING COMPONENT ]
 *                   ||||||
 *                   vvvvvv
 *            [ Blaze SubSystems ]
 * 
 * @author David Moss
 */

#include "Blaze.h"

configuration BlazeCentralWiringC {
  provides {
    interface CentralWiring;
    interface GeneralIO as Csn;
    interface GeneralIO as Gdo0_io;
    interface GeneralIO as Gdo2_io;
    interface GpioInterrupt as Gdo0_int;
    interface GpioInterrupt as Gdo2_int;
    interface BlazeConfig;
    interface BlazeRegSettings;
  }
  
  uses {
    interface GeneralIO as ChipCsn[ radio_id_t id ];
    interface GeneralIO as ChipGdo0_io[ radio_id_t id ];
    interface GeneralIO as ChipGdo2_io[ radio_id_t id ];
    interface GpioInterrupt as ChipGdo0_int[ radio_id_t id ];
    interface GpioInterrupt as ChipGdo2_int[ radio_id_t id ];
    interface BlazeConfig as ChipConfig[ radio_id_t id ];
    interface BlazeRegSettings as ChipRegSettings[ radio_id_t id ];
  }
}

implementation {

  components BlazeCentralWiringP;
  CentralWiring = BlazeCentralWiringP;
  
  ChipCsn = BlazeCentralWiringP.ChipCsn;
  ChipGdo0_io = BlazeCentralWiringP.ChipGdo0_io;
  ChipGdo2_io = BlazeCentralWiringP.ChipGdo2_io;
  ChipGdo0_int = BlazeCentralWiringP.ChipGdo0_int;
  ChipGdo2_int = BlazeCentralWiringP.ChipGdo2_int;
  ChipConfig = BlazeCentralWiringP.ChipConfig;
  ChipRegSettings = BlazeCentralWiringP.ChipRegSettings;
  
  Csn = BlazeCentralWiringP.Csn;
  Gdo0_io = BlazeCentralWiringP.Gdo0_io;
  Gdo2_io = BlazeCentralWiringP.Gdo2_io;
  Gdo0_int = BlazeCentralWiringP.Gdo0_int;
  Gdo2_int = BlazeCentralWiringP.Gdo2_int;
  BlazeConfig = BlazeCentralWiringP.BlazeConfig;
  BlazeRegSettings = BlazeCentralWiringP.BlazeRegSettings;
  
}

