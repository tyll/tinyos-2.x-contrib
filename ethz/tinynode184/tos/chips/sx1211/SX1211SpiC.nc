/**
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 * Implementation of basic SPI primitives for the Semtech/Xemics SX1211 radio.
 *
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Henri Dubois-Ferriere
 * @version $Revision$ $Date$
 */

#include "SX1211.h"

generic configuration SX1211SpiC() {

  provides interface Resource;

  // registers
  provides interface SX1211Register as MCParam;
  provides interface SX1211Register as IRQParam;
  provides interface SX1211Register as RXParam;
  provides interface SX1211Register as TXParam;
  provides interface SX1211Register as SYNCParam;
  provides interface SX1211Register as PCKTParam;
  /*provides interface SX1211Register as MCParam1;
  provides interface SX1211Register as MCParam2;
  provides interface SX1211Register as MCParam3;
  provides interface SX1211Register as MCParam4;
  provides interface SX1211Register as IrqParam5;
  provides interface SX1211Register as IrqParam6;
  provides interface SX1211Register as TXParam7;
  provides interface SX1211Register as RXParam8;
  provides interface SX1211Register as RXParam9;
  provides interface SX1211Register as RXParam10;
  provides interface SX1211Register as RXParam11;
  provides interface SX1211Register as RXParam12;
  provides interface SX1211Register as Pattern13;
  provides interface SX1211Register as Pattern14;
  provides interface SX1211Register as Pattern15;
  provides interface SX1211Register as Pattern16;
  provides interface SX1211Register as OscParam17;
  provides interface SX1211Register as OscParam18;
  provides interface SX1211Register as TParam19;
  provides interface SX1211Register as TParam21;
  provides interface SX1211Register as TParam22;
  */
  // fifos
  provides interface SX1211Fifo;

}

implementation {

  enum {
    CLIENT_ID = unique( "SX1211Spi.Resource" ),
  };

  components SX1211SpiP as Spi;
  
  Resource = Spi.Resource[ CLIENT_ID ];

  // registers
  MCParam = Spi.Reg;//[ MCParam_0 ];
  IRQParam = Spi.Reg;
  RXParam = Spi.Reg;
  TXParam = Spi.Reg;
  SYNCParam = Spi.Reg;
  PCKTParam = Spi.Reg;
  /*
  MCParam1   = Spi.Reg[ MCParam_1 ];
  MCParam2   = Spi.Reg[ MCParam_2 ];
  MCParam3   = Spi.Reg[ MCParam_3 ];
  MCParam4   = Spi.Reg[ MCParam_4 ];
  IrqParam5  = Spi.Reg[ IrqParam_5 ];
  IrqParam6  = Spi.Reg[ IrqParam_6 ];
  TXParam7   = Spi.Reg[ TXParam_7 ];
  RXParam8   = Spi.Reg[ RXParam_8 ];
  RXParam9   = Spi.Reg[ RXParam_9 ];
  RXParam10  = Spi.Reg[ RXParam_10 ];
  RXParam11  = Spi.Reg[ RXParam_11 ];
  RXParam12  = Spi.Reg[ RXParam_12 ];
  Pattern13  = Spi.Reg[ Pattern_13 ];
  Pattern14  = Spi.Reg[ Pattern_14 ];
  Pattern15  = Spi.Reg[ Pattern_15 ];
  Pattern16  = Spi.Reg[ Pattern_16 ];
  OscParam17 = Spi.Reg[ OscParam_17 ];
  OscParam18 = Spi.Reg[ OscParam_18 ];
  TParam19   = Spi.Reg[ TParam_19 ];
  TParam21   = Spi.Reg[ TParam_21 ];
  TParam22   = Spi.Reg[ TParam_22 ];
  */
  SX1211Fifo = Spi.Fifo;
}

