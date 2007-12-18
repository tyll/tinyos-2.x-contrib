/*
 * Copyright (c) 2005 Arched Rock Corporation 
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of the Arched Rock Corporation nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 * 
 * @author Phil Buonadonna
 */
 
/**
 * Adapted for nxtmote.
 * @author Rasmus Ulslev Pedersen
 */

configuration HplAT91SP1C 
{
  provides {
    interface HplAT91SPI;
  }
}

implementation
{
  components HplAT91SPIP;
  components HplAT91InterruptM;
  components PlatformP;

  HplAT91SPI = HplAT91SPIP;

  HplAT91SPIP.Init <- PlatformP.InitL1;

  //TODO
  HplAT91SPIP.SSP1Irq -> HplAT91InterruptM.AT91Irq[0/*PPID_SSP1*/];
}
