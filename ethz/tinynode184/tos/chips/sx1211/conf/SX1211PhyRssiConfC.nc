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

/**
 * Implementation of SX1211RssiConf and SX1211PhyConf interfaces.
 *
 * @author Henri Dubois-Ferriere
 */



configuration SX1211PhyRssiConfC {

  provides interface SX1211PhyConf;
  provides interface SX1211RssiConf;
  provides interface SX1211PhySwitch;
  
  provides interface Get<uint32_t> as GetTxTime;
  provides interface Get<uint32_t> as GetRxTime;

}

implementation {
  
  components SX1211PhyRssiConfP;

  components MainC;
  MainC.SoftwareInit -> SX1211PhyRssiConfP.Init;

  components new SX1211SpiC();
  SX1211PhyRssiConfP.SpiResource -> SX1211SpiC;
  SX1211PhyRssiConfP.MCParam -> SX1211SpiC.MCParam;
  SX1211PhyRssiConfP.IRQParam -> SX1211SpiC.IRQParam;
  SX1211PhyRssiConfP.RXParam -> SX1211SpiC.RXParam;
  SX1211PhyRssiConfP.TXParam -> SX1211SpiC.TXParam;
  SX1211PhyRssiConfP.SYNCParam -> SX1211SpiC.SYNCParam;
  SX1211PhyRssiConfP.PCKTParam -> SX1211SpiC.PCKTParam;

  SX1211PhyConf = SX1211PhyRssiConfP;
  SX1211RssiConf = SX1211PhyRssiConfP;
  SX1211PhySwitch = SX1211PhyRssiConfP;
  GetTxTime = SX1211PhyRssiConfP.GetTxTime;
  GetRxTime = SX1211PhyRssiConfP.GetRxTime;
  
  components HplSX1211PinsC;
  SX1211PhyRssiConfP.DataPin       -> HplSX1211PinsC.DataPin;
  SX1211PhyRssiConfP.Irq0Pin       -> HplSX1211PinsC.Irq0Pin;
  SX1211PhyRssiConfP.Irq1Pin       -> HplSX1211PinsC.Irq1Pin;
  SX1211PhyRssiConfP.PllLockPin    -> HplSX1211PinsC.PllLockPin;
  
    components new Alarm32khz16C();
  SX1211PhyRssiConfP.SwitchTimer -> Alarm32khz16C.Alarm;
  
  components HplSX1211InterruptsC;
  SX1211PhyRssiConfP.PllInterrupt -> HplSX1211InterruptsC.PllInterrupt;

  components LocalTime32khzC as localTime2;
  SX1211PhyRssiConfP.LocalTime -> localTime2;
}
