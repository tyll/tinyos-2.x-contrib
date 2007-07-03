/*
 * Copyright (c) 2007 Copenhagen Business School
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
 * - Neither the name of CBS nor the names of
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
 * NXT AVR initialization.
 *
 * @author Rasmus Ulslev Pedersen
 */

configuration NxtAvrC{
  provides interface Init;
}
implementation {
  components MainC, NxtAvrM, HalAT91I2CMasterC;
  
  NxtAvrM.I2CPacket -> HalAT91I2CMasterC.I2CPacket;
  NxtAvrM.Boot -> MainC.Boot;
  
  Init = NxtAvrM.Init;
  //TestI2CM.Init <- PlatformP.InitL2;
  
  components HplAT91_GPIOC;
  HalAT91I2CMasterC.I2CSCL -> HplAT91_GPIOC.HplAT91_GPIOPin[AT91C_PA4_TWCK];
  HalAT91I2CMasterC.I2CSDA -> HplAT91_GPIOC.HplAT91_GPIOPin[AT91C_PA3_TWD];
}
