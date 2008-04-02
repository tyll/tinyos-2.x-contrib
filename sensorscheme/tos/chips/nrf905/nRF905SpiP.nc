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

/**
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Leon Evers
 * @version $Revision$ $Date$
 */

configuration nRF905SpiP {

  provides interface Resource[ uint8_t id ];
  provides interface nRF905Fifo as Fifo;
  provides interface nRF905Register as Reg[ uint8_t id ];

}

implementation {

  components nRF905SpiImplP as SpiP;
  Resource = SpiP;
  Fifo = SpiP;
  Reg = SpiP;

  components new HplnRF905SpiC();
  SpiP.SpiResource -> HplnRF905SpiC;
  SpiP.SpiByte -> HplnRF905SpiC;
  SpiP.SpiPacket -> HplnRF905SpiC;

  components MainC;
  MainC.SoftwareInit -> SpiP;

  components HplnRF905PinsC;
  SpiP.NssConfigPin -> HplnRF905PinsC.NssConfigPin;
  SpiP.NssDataPin -> HplnRF905PinsC.NssDataPin;

  components new Msp430GpioC() as DPin;

}
