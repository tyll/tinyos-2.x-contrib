/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


/**
 * Configuration for wiring the platform dependend part of the Mc13192 code
 * @author Tor Petterson <motor@diku.dk>
 */
 
 configuration Mc13192HardwareC
{
  provides interface mc13192Regs;
  provides interface mc13192Pins;
  provides interface mc13192Interrupt;
  provides interface StdControl;
}
implementation
{
  components Mc13192HwInterruptP, Mc13192RegsP, Mc13192PinsP;
  components Hcs08SpiC, Hcs08GeneralIOC, Hcs08InterruptC;
  
  Hcs08InterruptC.Hcs08Interrupt <- Mc13192HwInterruptP.Hcs08Interrupt;
  Hcs08SpiC.Hcs08Spi <- Mc13192RegsP;
  Hcs08GeneralIOC.PortC4 <- Mc13192PinsP.Reset;
  Hcs08GeneralIOC.PortC3 <- Mc13192PinsP.RXTXEN;
  Hcs08GeneralIOC.PortC2 <- Mc13192PinsP.ATTN;
  Hcs08GeneralIOC.PortC6 <- Mc13192PinsP.AntCtrl;
  
  mc13192Regs = Mc13192RegsP;
  mc13192Interrupt = Mc13192HwInterruptP;
  mc13192Pins = Mc13192PinsP;
  StdControl = Mc13192PinsP.StdControl;
  StdControl = Hcs08SpiC.StdControl;
}