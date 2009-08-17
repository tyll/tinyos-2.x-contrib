/*
 * Copyright (c) 2006 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCH ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author Alec Woo <awoo@archrock.com>
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Philipp Sommer <sommer@tik.ee.ethz.ch> (Atmega1281 port)
 */

#include "Atm1281Usart.h"

interface HplAtm1281Usart {
  
  async command void resetUsart();
  
  async command error_t enableIntr();
  async command error_t disableIntr();
  async command error_t enableTxIntr();
  async command error_t disableTxIntr();
  async command error_t enableRxIntr();
  async command error_t disableRxIntr();

  async command bool isUart();
  async command void enableUart();
  async command void disableUart();
  async command void setModeUart(Atm1281UartUnionConfig_t* config);

  async command void enableSpi();
  async command void disableSpi();
  async command bool isSpi();
  async command void setModeSpi(Atm1281SpiUnionConfig_t* config);

  async command bool isTxEmpty();
  async command bool isRxEmpty();
  async command void tx(uint8_t data);
  async command uint8_t rx();

  async command bool isTxIntrPending();
  async command bool isRxIntrPending();
  async command void clrRxIntr();
  async command void clrTxIntr();
  async command void clrIntr();

}
