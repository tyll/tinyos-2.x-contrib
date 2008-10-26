
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
 * Exports Timer1 as Alarm/Counter interfaces This version uses the
 *  HPL timer interface, it has been replaced by
 *  HPLCC2430Timer1AlarmCounterP that uses Timer1 directly. This
 *  conserves stackspace in the absence of inline.
 *
 * Note: The fake interrupt mask for compare channels has NOT been
 * implemented - this causes tremendous jitter in the timer intervals
 *
 * isRunning is not implemented
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

configuration CC2430Timer1AlarmCounterC {
  provides interface Counter<T32khz, uint16_t>;
  provides interface Alarm<T32khz, uint16_t>[ uint8_t id ];
} implementation {

  components new CC2430Timer1AlarmCounterP(T32khz);
  components MainC, HplCC2430Timer1P;

  MainC.SoftwareInit -> HplCC2430Timer1P;
  MainC.SoftwareInit -> CC2430Timer1AlarmCounterP.Init;
  CC2430Timer1AlarmCounterP.Timer1 -> HplCC2430Timer1P;

  Alarm[0] = CC2430Timer1AlarmCounterP.Alarm0;
  Alarm[1] = CC2430Timer1AlarmCounterP.Alarm1;
  Alarm[2] = CC2430Timer1AlarmCounterP.Alarm2;
  Alarm[3] = CC2430Timer1AlarmCounterP.Alarm3;
  Counter = CC2430Timer1AlarmCounterP;
}
