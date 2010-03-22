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

/**
 * Make sure we aren't trying to compile multiple LPL directories into the
 * radio stack
 */
 
#ifndef WOR_H
#define WOR_H

/**
 * The crystal used for the radio must be defined for WoR calculations
 */
#ifndef CCXX00_CRYSTAL_KHZ
#define CCXX00_CRYSTAL_KHZ 26000
#endif

/**
 * The radio seems to forget it's supposed to be duty cycling sometimes.
 * The kick timer reminds the radio periodically to enable WoR.
 * If the radio doesn't receive any packets while it's supposed to be in 
 * WoR mode, how else is the microcontroller supposed to know to fix the 
 * problem?
 */
#ifndef WOR_KICK_TIMER
#define WOR_KICK_TIMER 15360
#endif


/**
 * WORCTRL register bitfields
 */
enum ccxx00_worctrl_register {
  CCXX00_WORCTRL_RC_PD = 7,
  CCXX00_WORCTRL_EVENT1 = 4,
  CCXX00_WORCTRL_RC_CAL = 3,
  CCXX00_WORCTRL_WOR_RES = 0,
};

/**
 * MCSM2 register bitfields
 */
enum ccxx00_mcsm2_register {
  CCXX00_MCSM2_RX_TIME_RSSI = 4,
  CCXX00_MCSM2_RX_TIME_QUAL = 3,
  CCXX00_MCSM2_RX_TIME = 0,
};

/**
 * Mask the fields to 0
 */
enum ccxx00_mcsm2_mask {
  CCXX00_MCSM2_RX_TIME_RSSI_MASK = 0xEF,
  CCXX00_MCSM2_RX_TIME_QUAL_MASK = 0xF7,
  CCXX00_MCSM2_RX_TIME_MASK = 0xF8,
};

#endif

