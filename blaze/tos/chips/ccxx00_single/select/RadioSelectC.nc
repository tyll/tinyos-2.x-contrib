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
 * Above this layer, the Send and Receive interfaces are radio-agnostic 
 * and not parameterized.  The SplitControl interface remains parameterized
 * because there is no metadata associated with it.
 *
 * This layer selects which radio to use based on packet properties, and 
 * everything below it is parameterized by radio ID.  
 * It also the logical place to intersect Send and SplitControl. It queues up a 
 * SplitControl.stop request when we're in the middle of sending, and blocks
 * send requests when the radio is off.
 *
 * Use the RadioSelect interface to change the radio a particular message
 * uses to send.
 * 
 * @author David Moss
 */
 
configuration RadioSelectC {
  provides {
    interface SplitControl as BlazeSplitControl[radio_id_t radioId];
    interface SplitControl;
    interface Send;
    interface Receive;    
    interface RadioSelect;
  }
  
  uses {
    interface SplitControl as SubControl;
    interface Send as SubSend;
    interface Receive as SubReceive;
  }
}

implementation {

  SplitControl = SubControl;
  BlazeSplitControl[0] = SubControl;
  Send = SubSend;
  Receive = SubReceive;
  
  components RadioSelectDummyP;
  RadioSelect = RadioSelectDummyP;
  BlazeSplitControl = RadioSelectDummyP;
    
}

