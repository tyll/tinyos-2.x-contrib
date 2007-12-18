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
 * Test of I2C. 
 *
 * @author Rasmus Ulslev Pedersen
 */

configuration TestI2CC{}
implementation {
  components MainC, TestI2CM, PlatformP, HalAT91I2CMasterC;
  
  TestI2CM.I2CPacket -> HalAT91I2CMasterC.I2CPacket;
  //TestI2CM.HplAT91I2C <- HplAT91I2CC.HplAT91I2C;
  
  TestI2CM.Init <- PlatformP.InitL2;
  TestI2CM.Boot -> MainC.Boot;
  components HalAT91I2CMasterP;
  TestI2CM.SubInit -> HalAT91I2CMasterP.Init;
  
  components HalLCDC;
  TestI2CM -> HalLCDC.HalLCD;
  
  components HplAT91PitC;
  TestI2CM.PitTimer -> HplAT91PitC.HplAT91Pit;
  
  components HplAT91_GPIOC;
  HalAT91I2CMasterC.I2CSCL -> HplAT91_GPIOC.HplAT91_GPIOPin[AT91C_PA4_TWCK];
  HalAT91I2CMasterC.I2CSDA -> HplAT91_GPIOC.HplAT91_GPIOPin[AT91C_PA3_TWD];
  
}
