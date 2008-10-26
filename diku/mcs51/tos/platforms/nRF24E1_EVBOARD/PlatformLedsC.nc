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
 * This component provides 3 leds as I/O pins. The leds are
 * initialized through the componts LedsC/LedsP. The leds on the
 * nrf24e1 are active low which is the assumpiton made by
 * LedsC/LedsP.
 *
 * @author Mikkel Jønsson <jonsson@diku.dk>
 */

configuration PlatformLedsC
{
  provides interface GeneralIO as Led0;
  provides interface GeneralIO as Led1;
  provides interface GeneralIO as Led2;
  uses interface Init;
}
implementation
{
  components HplnRF24E1GeneralIOC,
    PlatformP,
    new ReverseGPIOP() as Led0_rev,
    new ReverseGPIOP() as Led1_rev,
    new ReverseGPIOP() as Led2_rev;
    
  // Let LedsP (from system) handle the Led init...
  Init = PlatformP.LedsInit;

  Led0_rev -> HplnRF24E1GeneralIOC.P10; //Red
  Led1_rev -> HplnRF24E1GeneralIOC.P11; //Green
  Led2_rev -> HplnRF24E1GeneralIOC.P07; //Yellow
  
  Led0 = Led0_rev.Out;
  Led1 = Led1_rev.Out;
  Led2 = Led2_rev.Out;

}
