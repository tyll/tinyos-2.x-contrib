
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
 * @author Martin Leopold
 *
 */

configuration LoggerPinsC {

  provides interface GeneralIO as Starter;
  provides interface GeneralIO as Trigger;
  provides interface GeneralIO as Mcu;
  provides interface GeneralIO[uint8_t id];

}

implementation
{    
  components HplCC2430GeneralIOC as HplGeneralIOC;
  
  Mcu          = HplGeneralIOC.P05;
  GeneralIO[1] = HplGeneralIOC.P04;
  GeneralIO[2] = HplGeneralIOC.P14;
  GeneralIO[3] = HplGeneralIOC.P15;
  GeneralIO[4] = HplGeneralIOC.P16;
  GeneralIO[5] = HplGeneralIOC.P17;
  GeneralIO[6] = HplGeneralIOC.P07;
  Starter      = HplGeneralIOC.P11;

  Trigger = HplGeneralIOC.P20; // Located on P2_4 on the devkit

  Starter = HplGeneralIOC.P13; // backup pin  
}
