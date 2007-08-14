/*
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
 * Implementation of basic SPI primitives for the ChipCon CC2420 radio.
 *
 * @author Jonathan Hui <jhui@archrock.com>
 * @version $Revision$ $Date$
 */

#include <CC2430_CSP.h>
#include <ioCC2430.h>

generic configuration CC2420SpiC() {

  provides interface Resource;

  // commands
  provides interface CC2420Strobe as SFLUSHRX;
  provides interface CC2420Strobe as SFLUSHTX;
  provides interface CC2420Strobe as SNOP;
  provides interface CC2420Strobe as SRXON;
  provides interface CC2420Strobe as SRFOFF;
  provides interface CC2420Strobe as STXON;
  provides interface CC2420Strobe as STXONCCA;
  provides interface CC2420Strobe as SXOSCON;
  provides interface CC2420Strobe as SXOSCOFF;

  // registers
  provides interface CC2420Register as FSCTRL;
  provides interface CC2420Register as IOCFG0;
  provides interface CC2420Register as IOCFG1;
  provides interface CC2420Register as MDMCTRL0;
  provides interface CC2420Register as MDMCTRL1;
  provides interface CC2420Register as RXCTRL1;
  provides interface CC2420Register as TXCTRL;

  // ram
  provides interface CC2420Ram as IEEEADR;
  provides interface CC2420Ram as PANID;
  provides interface CC2420Ram as SHORTADR;
  //  provides interface CC2420Ram as TXFIFO_RAM;

  // fifos
  provides interface CC2420Fifo as RXFIFO;
  provides interface CC2420Fifo as TXFIFO;

}

implementation {

  enum {
    CLIENT_ID = unique( "CC2420Spi.Resource" ),
  };

  components HplCC2420PinsC as Pins;
  components CC2420SpiP as Spi;
  
  Resource = Spi.Resource[ CLIENT_ID ];

  // commands
  SFLUSHRX = Spi.Strobe[ _CC2430_ISFLUSHRX ];
  SFLUSHTX = Spi.Strobe[ _CC2430_ISFLUSHTX ];

  // I don't know if this is safe - it is not an immediate strobe
  //  One might issue an unknown opcode instead (p. 189 bottom page)
  SNOP = Spi.Strobe[     _CC2430_SNOP ];
  SRXON = Spi.Strobe[    _CC2430_ISRXON ];
  SRFOFF = Spi.Strobe[   _CC2430_ISRFOFF ];
  STXON = Spi.Strobe[    _CC2430_ISTXON ];
  STXONCCA = Spi.Strobe[ _CC2430_ISTXONCCA ];

  // Unknown opcodes - should be executed as nop
#define _CC2420_SXOSCON 0x10
#define _CC2420_SXOSCOFF 0x10

  SXOSCON = Spi.Strobe [ _CC2420_SXOSCON ]; // What to do about these two?
  SXOSCOFF = Spi.Strobe[ _CC2420_SXOSCOFF ];

  // registers 
  // The generic-module system does not allow pointers, so we cast a bit
  FSCTRL = Spi.Reg[  (uint16_t) &_CC2430_FSCTRL    ];
  IOCFG0 = Spi.Reg[  (uint16_t) &_CC2430_IOCFG0    ];
  IOCFG1 = Spi.Reg[  (uint16_t) &_CC2430_IOCFG1    ];
  MDMCTRL0 = Spi.Reg[(uint16_t) &_CC2430_MDMCTRL0  ]; // Read 2 consecutive bytes: 0+1
  MDMCTRL1 = Spi.Reg[(uint16_t) &_CC2430_MDMCTRL1  ]; // Read 2 consecutive bytes: 2+3
  RXCTRL1 = Spi.Reg [(uint16_t) &_CC2430_RXCTRL1   ];
  TXCTRL = Spi.Reg  [(uint16_t) &_CC2430_TXCTRL    ];


  // ram
  // These designate the _starting_ address the call supplies the length
  // So we pick the first byte of the multi-byte register and hope the
  // program supplies the appropriate length.. And that endianess is
  // right 'n all that =]
  //
  // The ram interface seems to be unused in the stack anyway...
  // except TXFIFO_RAM is used in Send.modify, which is not used
  // anywhere. 
  //
  // There is no equivalent to Ram access to TXFIFO in cc2420 in cc2430

  IEEEADR =    Spi.Ram[ (uint16_t) &_CC2430_IEEE_ADDR0 ];
  PANID =      Spi.Ram[ (uint16_t) &_CC2430_PANIDH ];
  SHORTADR =   Spi.Ram[ (uint16_t) &_CC2430_SHORTADDRH ];

  //TXFIFO_RAM = Spi.Ram[ _CC2430_TXFIFO ];

  // fifos
  RXFIFO = Spi.Fifo[ CC2420_RXFIFO ];
  TXFIFO = Spi.Fifo[ CC2420_TXFIFO ];

}

