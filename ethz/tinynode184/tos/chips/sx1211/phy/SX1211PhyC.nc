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

configuration SX1211PhyC {
  provides interface SX1211PhyRxTx;
  provides interface SX1211PhyRssi;
  provides interface SX1211PhyRxFrame;
  provides interface SplitControl;
}
implementation {

  components SX1211PhyP;

  components new SX1211SpiC();
  SX1211PhyP.SX1211Fifo -> SX1211SpiC;
  SX1211PhyP.SpiResourceRX -> SX1211SpiC;

  components new SX1211SpiC() as SpiTX;
  SX1211PhyP.SpiResourceTX -> SpiTX;

  components new SX1211SpiC() as SpiConfig;
  SX1211PhyP.SpiResourceConfig -> SpiConfig;

  components new SX1211SpiC() as SpiRSSI;
  SX1211PhyP.SpiResourceRssi -> SpiRSSI;

  components HplSX1211InterruptsC;
  SX1211PhyP.Interrupt0 -> HplSX1211InterruptsC.Interrupt0;
  SX1211PhyP.Interrupt1 -> HplSX1211InterruptsC.Interrupt1;


  SX1211PhyRxTx = SX1211PhyP;
  SplitControl = SX1211PhyP;
  SX1211PhyRssi = SX1211PhyP;
  SX1211PhyRxFrame = SX1211PhyP;

  components MainC;
  MainC.SoftwareInit -> SX1211PhyP.Init;

  components SX1211PatternConfC;
  SX1211PhyP.SX1211PatternConf -> SX1211PatternConfC;

  components SX1211IrqConfC;
  SX1211PhyP.SX1211IrqConf -> SX1211IrqConfC;

  components SX1211PhyRssiConfC;
  SX1211PhyP.SX1211RssiConf -> SX1211PhyRssiConfC;
  SX1211PhyP.SX1211PhySwitch -> SX1211PhyRssiConfC;
  SX1211PhyP.SX1211PhyConf -> SX1211PhyRssiConfC;

  components new Alarm32khz16C();
  SX1211PhyP.Alarm32khz16 -> Alarm32khz16C.Alarm;
#if 0
  components new Msp430GpioC() as DpinM, HplMsp430GeneralIOC;
  DpinM -> HplMsp430GeneralIOC.Port41;
  SX1211PhyP.Dpin   -> DpinM;
#endif
}



