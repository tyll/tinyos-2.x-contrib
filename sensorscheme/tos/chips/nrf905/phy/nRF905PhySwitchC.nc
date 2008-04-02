/* 
 * Copyright (c) 2008, University of Twente (UTWENTE), the Netherlands.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the University of Twente (UTWENTE)
 *   nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ========================================================================
 */

/*
 * @author Leon Evers
 *
 */


configuration nRF905PhySwitchC {
  
  provides interface nRF905PhySwitch;

}
implementation {

  components nRF905PhySwitchP;
  nRF905PhySwitch = nRF905PhySwitchP;

  components HplnRF905PinsC;
  nRF905PhySwitchP.AntSelTXPin   -> HplnRF905PinsC.AntSelTXPin;
  nRF905PhySwitchP.AntSelRXPin   -> HplnRF905PinsC.AntSelRXPin;
  nRF905PhySwitchP.DataPin       -> HplnRF905PinsC.DataPin;
  nRF905PhySwitchP.ModeSel0Pin   -> HplnRF905PinsC.ModeSel0Pin;
  nRF905PhySwitchP.ModeSel1Pin   -> HplnRF905PinsC.ModeSel1Pin;
  nRF905PhySwitchP.Irq0Pin       -> HplnRF905PinsC.Irq0Pin;
  nRF905PhySwitchP.Irq1Pin       -> HplnRF905PinsC.Irq1Pin;

  components MainC;
  MainC.SoftwareInit ->   nRF905PhySwitchP.Init;
}
