/*
 * Copyright (c) 2007 nxtmote project
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
 * - Neither the name of nxtmote project nor the names of
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
 * Initialization of NXT AVR.
 *
 * @author Rasmus Ulslev Pedersen
 */

#include "I2C.h"

#define   DEVICE_ADR                    0x01
#define   COPYRIGHTSTRING               "Let's samba nxt arm in arm, (c)LEGO System A/S"
#define   COPYRIGHTSTRINGLENGTH         46    /* Number of bytes checked in COPYRIGHTSTRING */

module NxtAvrM
{
  provides interface Init;
  
  uses interface I2CPacket<TI2CBasicAddr>;

}

implementation
{
  static uint8_t CopyrightStr[] = {"\xCC"COPYRIGHTSTRING};

  command error_t Init.init() {
    error_t error;
    uint16_t devAddr;
    uint8_t* mI2CBuffer;
    uint8_t len;

    mI2CBuffer = CopyrightStr;
    devAddr = DEVICE_ADR;
    len = COPYRIGHTSTRINGLENGTH + 1;
  
    //write something to the I2C bus here
    error = call I2CPacket.write(I2C_START | I2C_STOP, devAddr, len, mI2CBuffer);
    
    return SUCCESS;
  }
  
  async event void I2CPacket.readDone(error_t error, uint16_t addr, 
					     uint8_t length, uint8_t* data) {
    return;
  }

  async event void I2CPacket.writeDone(error_t error, uint16_t addr, 
						     uint8_t length, uint8_t* data) { 
    return;
  }
}
