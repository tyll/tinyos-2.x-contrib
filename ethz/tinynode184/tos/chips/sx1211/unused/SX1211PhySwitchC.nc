/* 
 * Copyright (c) 2006, Ecole Polytechnique Federale de Lausanne (EPFL),
 * Switzerland.
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
 * - Neither the name of the Ecole Polytechnique Federale de Lausanne (EPFL) 
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
 * @author Henri Dubois-Ferriere
 *
 */


configuration SX1211PhySwitchC {
  
  provides interface SX1211PhySwitch;

}
implementation {

  components SX1211PhySwitchP;
  SX1211PhySwitch = SX1211PhySwitchP;

  components HplSX1211PinsC;
  SX1211PhySwitchP.DataPin       -> HplSX1211PinsC.DataPin;
  SX1211PhySwitchP.ModeSel0Pin   -> HplSX1211PinsC.ModeSel0Pin;
  SX1211PhySwitchP.ModeSel1Pin   -> HplSX1211PinsC.ModeSel1Pin;
  SX1211PhySwitchP.Irq0Pin       -> HplSX1211PinsC.Irq0Pin;
  SX1211PhySwitchP.Irq1Pin       -> HplSX1211PinsC.Irq1Pin;
  SX1211PhySwitchP.PllLockPin    -> HplSX1211PinsC.PllLockPin;
  components MainC;
  MainC.SoftwareInit ->   SX1211PhySwitchP.Init;


}
