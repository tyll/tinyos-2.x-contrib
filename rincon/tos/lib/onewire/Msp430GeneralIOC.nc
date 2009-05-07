/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

////////////////////////////////////////////////////////////////////////
// Msp430GeneralIOC.nc
//

generic module Msp430GeneralIOC() {
  // Sigh. MSP430 chose its own HPL interface.
  // Atmel uses the one in interfaces/. Create
  // an impedance match for MSP430.

  provides interface GeneralIO;
  uses interface HplMsp430GeneralIO as Pin;
}

implementation {
  async command void GeneralIO.set() {
    call Pin.set();
  }

  async command void GeneralIO.clr() {
    call Pin.clr();
  }

  async command void GeneralIO.toggle() {
    call Pin.toggle();
  }

  async command bool GeneralIO.get() {
    return call Pin.get();
  }

  async command void GeneralIO.makeInput() {
    call Pin.makeInput();
  }

  async command bool GeneralIO.isInput() {
    return call Pin.isInput();
  }

  async command void GeneralIO.makeOutput() {
    call Pin.makeOutput();
  }

  async command bool GeneralIO.isOutput() {
    return call Pin.isOutput();
  }
}

// EOF Msp430GeneralIOC.nc

