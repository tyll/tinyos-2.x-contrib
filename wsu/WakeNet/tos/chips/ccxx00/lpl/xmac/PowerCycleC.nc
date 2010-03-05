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
 * Use this component to duty cycle the radio. When a message is heard, 
 * disable DutyCycling.
 *
 * @author David Moss dmm@rincon.com
 */

configuration PowerCycleC {
  provides {
    interface PowerCycle[radio_id_t radioId];
    interface SplitControl[radio_id_t radioId];
    interface Receive[radio_id_t radioId];
    interface Send[radio_id_t radioId];
    interface State as SplitControlState;
    interface State as RadioPowerState;
  }
  
  uses {
    interface Send as SubSend[radio_id_t radioId];
    interface Receive as SubReceive[radio_id_t radioId];
    interface SplitControl as SubControl[radio_id_t radioId];
  }
}

implementation {
  components PowerCycleP,
      MainC,
      LedsC,
      new StateC() as RadioPowerStateC,
      new StateC() as SplitControlStateC,
      PeriodicTimerC as OnTimerC,
      new TimerMilliC() as OffTimerC;
  
  /** PowerCycle */
  PowerCycle = PowerCycleP;
  
  /** SplitControl */
  SplitControl = PowerCycleP.SplitControl;
  SubControl = PowerCycleP.SubControl;
  SplitControlState = SplitControlStateC;
  RadioPowerState = RadioPowerStateC;
  
  /** Receive */
  Receive = PowerCycleP.Receive;
  SubReceive = PowerCycleP.SubReceive;
  
  /** Send */
  Send = PowerCycleP.Send;
  PowerCycleP.SubSend = SubSend;
  
  
  MainC.SoftwareInit -> PowerCycleP;
  
  PowerCycleP.RadioPowerState -> RadioPowerStateC;
  PowerCycleP.SplitControlState -> SplitControlStateC;
  PowerCycleP.OnTimer -> OnTimerC;
  PowerCycleP.OffTimer -> OffTimerC;
  PowerCycleP.Leds -> LedsC;
  
  components BlazeCentralWiringC;
  PowerCycleP.RxInterrupt -> BlazeCentralWiringC.Gdo0_int;
  
  components LplC;
  PowerCycleP.SendState -> LplC;
  
}


