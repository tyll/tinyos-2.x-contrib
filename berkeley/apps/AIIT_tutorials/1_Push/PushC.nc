#include <UserButton.h>

/**
 * Copyright (c) 2007 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Push - a minimal TinyOS 2.0 application
 *
 * Behavior: While the user button is pressed the red LED (led0) lights.
 *
 * Concepts Illustrated:
 *   module - the implementation of a functional element that can be 
 *            composed into a larger elements through configurations.
 *            This file, with a name ending in 'M' is an example module.
 *            Modules contain state (variables), internal functions,
 *            functions that implement one side of an interface, 
 *            and tasks that provide logical concurrency (not shown here).
 *            The implementation of a component is in terms of the 
 *            namespace provided by its interfaces.
 *         
 *   configuration - a component that composes a set of components by wiring
 *            together their interfaces.  
 *   commands - externally accessible functions that can be called across
 *            an interface between components, typically to initiate actions.
 *   events   - externally accessible handlers that can be signaled across
 *            and interface between components, typically to notify of 
 *            an occurance.
 *   interfaces - bidirectional collections of typed function signatures for
 *            commands and envents.
 *            This module uses three interfaces provided by lower level
 *            subsystems.
 *            See $TOSROOT/tinyos/tos/interfaces/
 *
 * @author David Culler <dculler@archrock.com>
 * @author Jaein Jeong  <jaein@eecs.berkeley.edu>
 * @version $Revision$ 
 *
 */

module PushC {
  uses {
    interface Boot;
    interface Notify<button_state_t>;
    interface Leds;
  }
}
implementation {
  event void Boot.booted() {
    call Notify.enable();
  }
 
  // state can be either BUTTON_PRESSED or BUTTON_RELEASED
  event void Notify.notify( button_state_t state ) {
    call Leds.led0Toggle();
  }
}

