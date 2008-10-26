
/*
 * Copyright (c) 2007 University of Copenhagen
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
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * 
 * @author Marcus Chang
 *
 */

generic configuration AdcSequenceDmaC() {
  provides interface AdcControl;
  provides interface StdControl as PortControl0;
  provides interface Read<int16_t> as Read0;
  provides interface StdControl as PortControl1;
  provides interface Read<int16_t> as Read1;
  provides interface StdControl as PortControl2;
  provides interface Read<int16_t> as Read2;
  provides interface StdControl as PortControl3;
  provides interface Read<int16_t> as Read3;
  provides interface StdControl as PortControl4;
  provides interface Read<int16_t> as Read4;
  provides interface StdControl as PortControl5;
  provides interface Read<int16_t> as Read5;
  provides interface StdControl as PortControl6;
  provides interface Read<int16_t> as Read6;
  provides interface StdControl as PortControl7;
  provides interface Read<int16_t> as Read7;
}

implementation {
  components MainC, AdcSequenceDmaP;
  MainC.SoftwareInit -> AdcSequenceDmaP.Init;

  AdcControl = AdcSequenceDmaP;
  Read0 = AdcSequenceDmaP.Read[0];
  Read1 = AdcSequenceDmaP.Read[1];
  Read2 = AdcSequenceDmaP.Read[2];
  Read3 = AdcSequenceDmaP.Read[3];
  Read4 = AdcSequenceDmaP.Read[4];
  Read5 = AdcSequenceDmaP.Read[5];
  Read6 = AdcSequenceDmaP.Read[6];
  Read7 = AdcSequenceDmaP.Read[7];
  PortControl0 = AdcSequenceDmaP.PortControl[0];
  PortControl1 = AdcSequenceDmaP.PortControl[1];
  PortControl2 = AdcSequenceDmaP.PortControl[2];
  PortControl3 = AdcSequenceDmaP.PortControl[3];
  PortControl4 = AdcSequenceDmaP.PortControl[4];
  PortControl5 = AdcSequenceDmaP.PortControl[5];
  PortControl6 = AdcSequenceDmaP.PortControl[6];
  PortControl7 = AdcSequenceDmaP.PortControl[7];
  
  components StdNullC as StdOutC;
  AdcSequenceDmaP.StdOut -> StdOutC;
  
  components new DmaC() as Dma1;
  AdcSequenceDmaP.Dma1 -> Dma1;

  components new DmaC() as Dma2;
  AdcSequenceDmaP.Dma2 -> Dma2;
}
