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
 * The SplitControlManager makes sure we do not try to turn both radios
 * on at the same time, and ensures we aren't trying to Send to a radio
 * that is currently turned off.
 *
 * When a radio is on, its power may be duty cycling underneath via LPL
 * functionality
 *
 * If a SplitControl.stop() command comes in during a Send, the stop()
 * command will proceed into deeper areas of the radio stack where
 * the Transmit branch must abort the send attempt.  No further sends will
 * be allowed until the radio is turned back on by the application layer.
 *
 * The SplitControlManager interface will allow other areas of the system
 * to see if a particular radio is on, off, or in a state of change.
 *
 * @author David Moss
 */
 
#include "SplitControlManager.h"
#include "Blaze.h"
 
configuration SplitControlManagerC {
  provides {
    interface SplitControl[radio_id_t radioId];
    interface Send[radio_id_t radioId];
    interface SplitControlManager[radio_id_t radioId];
  }
  
  uses {
    interface SplitControl as SubControl[radio_id_t radioId];
    interface Send as SubSend[radio_id_t radioId];
  }
}

implementation {
  
  components SplitControlManagerP;
  
  SplitControl = SplitControlManagerP.SplitControl;
  Send = SplitControlManagerP.Send;
  SplitControlManager = SplitControlManagerP;
  
  SubControl = SplitControlManagerP.SubControl;
  SubSend = SplitControlManagerP.SubSend;
  
  components LedsC;
  SplitControlManagerP.Leds -> LedsC;
  
}


