/**
 * Copyright (c) 2005-2006 Arched Rock Corporation
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
 * - Neither the name of the Arched Rock Corporation nor the names of
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
 * An implementation of the SPI on USART0 for the Atmega1281.
 * @author Jonathan Hui <jhui@archedrock.com>
 * @author Mark Hays
 * @author Philipp Sommer <sommer@tik.ee.ethz.ch> (Atmega1281 port)
 */

#include "Atm1281Usart.h"

generic configuration Atm1281Spi0C() {

  provides interface Resource;
  provides interface ResourceRequested;
  provides interface SpiByte;
  provides interface SpiPacket;

  uses interface Atm1281SpiConfigure;
}

implementation {

  enum {
    CLIENT_ID = unique(ATM1281_SPIO_BUS),
  };

  components Atm1281Spi0P as SpiP;


  Resource = SpiP.Resource[CLIENT_ID];
  SpiByte = SpiP.SpiByte;
  SpiPacket = SpiP.SpiPacket[CLIENT_ID];
  Atm1281SpiConfigure = SpiP.Atm1281SpiConfigure[CLIENT_ID];

  components new Atm1281Usart0C() as UsartC;
  ResourceRequested = UsartC;
  SpiP.ResourceConfigure[CLIENT_ID] <- UsartC.ResourceConfigure;
  SpiP.UsartResource[CLIENT_ID] -> UsartC.Resource;
  SpiP.UsartInterrupts -> UsartC.HplAtm1281UsartInterrupts;

}
