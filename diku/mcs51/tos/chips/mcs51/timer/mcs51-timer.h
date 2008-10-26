/*
 * Copyright (c) 2008 Polaric
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
 * - Neither the name of Polaric nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL POLARIC OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * @author Martin Leopold <leopold@polaric.dk>
 */

#ifndef _H_mcs51_timer_H
#define _H_mcs51_timer_H

typedef enum {
  MCS51_TIMER_MODE_13BIT = 0,
  MCS51_TIMER_MODE_16BIT = 1,
  MCS51_TIMER_MODE_8BIT_RELOAD = 2,
  MCS51_TIMER_MODE_DOUBLE_8BIT = 3
} mcs51_timer_mode_t;

typedef enum {
  MCS51_TIMER_SRC_SYSCLK = 0,
  MCS51_TIMER_SRC_EXT = 1
} mcs51_timer_src_t;

enum {
  MCS51_TCON_TF1 = 7,
  MCS51_TCON_TR1 = 6,
  MCS51_TCON_TF0 = 5,
  MCS51_TCON_TR0 = 4,
  MCS51_TCON_IE1 = 3,
  MCS51_TCON_IT1 = 2,
  MCS51_TCON_IE0 = 1,
  MCS51_TCON_IT0 = 0
};

enum {
  MCS51_TMOD_T0MODE_MASK = 0x03,
  MCS51_TMOD_T1MODE_MASK = 0x30,
  MCS51_TMOD_GATE1 = 7,
  MCS51_TMOD_CT1   = 6,
  MCS51_TMOD_M1M1  = 5,
  MCS51_TMOD_T1M0  = 4,
  MCS51_TMOD_GATE0 = 3,
  MCS51_TMOD_CT0   = 2,
  MCS51_TMOD_M0M1  = 1,
  MCS51_TMOD_T0M0  = 0
};

#endif //_H_mcs51_timer_H
