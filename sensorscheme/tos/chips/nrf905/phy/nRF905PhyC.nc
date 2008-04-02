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

configuration nRF905PhyC {
  provides interface nRF905PhyRxTx;
  provides interface nRF905PhyRssi;
  provides interface SplitControl;
}
implementation {

  components nRF905PhyP;

  components nRF905PhySwitchC;
  nRF905PhyP.nRF905PhySwitch -> nRF905PhySwitchC;

  components new nRF905SpiC();
  nRF905PhyP.nRF905Fifo -> nRF905SpiC;
  nRF905PhyP.SpiResourceRX -> nRF905SpiC;

  components new nRF905SpiC() as SpiTX;
  nRF905PhyP.SpiResourceTX -> SpiTX;

  components new nRF905SpiC() as SpiConfig;
  nRF905PhyP.SpiResourceConfig -> SpiConfig;

  components new nRF905SpiC() as SpiRSSI;
  nRF905PhyP.SpiResourceRssi -> SpiRSSI;

  components HplnRF905InterruptsC;
  nRF905PhyP.Interrupt0 -> HplnRF905InterruptsC.Interrupt0;
  nRF905PhyP.Interrupt1 -> HplnRF905InterruptsC.Interrupt1;


  nRF905PhyRxTx = nRF905PhyP;
  SplitControl = nRF905PhyP;
  nRF905PhyRssi = nRF905PhyP;

  components MainC;
  MainC.SoftwareInit -> nRF905PhyP.Init;

  components nRF905PatternConfC;
  nRF905PhyP.nRF905PatternConf -> nRF905PatternConfC;

  components nRF905IrqConfC;
  nRF905PhyP.nRF905IrqConf -> nRF905IrqConfC;

  components nRF905PhyRssiConfC;
  nRF905PhyP.nRF905RssiConf -> nRF905PhyRssiConfC;

  components new Alarm32khz16C();
  nRF905PhyP.Alarm32khz16 -> Alarm32khz16C.Alarm;
#if 0
  components new Msp430GpioC() as DpinM, HplMsp430GeneralIOC;
  DpinM -> HplMsp430GeneralIOC.Port41;
  nRF905PhyP.Dpin   -> DpinM;
#endif
}



