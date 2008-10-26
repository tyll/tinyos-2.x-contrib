
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
/*
 * This interface export the two mutually exclusive interfaces SpiByte
 * and SpiPacet. This implementation has considerable overhead and
 * should not be used when performance is concerned.
 *
 * With a fast clock writing relatively short sequences of bytes using
 * the non-interrupt driven SpiByte is considerably faster than
 * writing through the interrupt controller.
 *
 * For example with a 4 MHz SPI clock writing 10 bytes using
 * SpiByte.send takes app 30 us, while the interrupt driven
 * SpiPacket.send takes app 135 us, where something like 80 us is
 * spent processing the interrupt events.
 */

/**
 *
 * @author Martin Leopold <leopold@polaric.dk>
 */

#include <iocip51.h>
#include <spi.h>

module HalCip51SimpleSPIP {
  provides interface SpiByte;
  provides interface SpiPacket;
  provides interface SpiControl;
  provides interface Init;
} implementation {

  uint8_t *tx_buf;
  uint8_t norace *rx_buf, *tx_buf_start, *tx_buf_end, *rx_buf_end;
  uint8_t mode;

  command error_t Init.init(){
    tx_buf=NULL;
    mode = _BV(SPI_4WIRE) | _BV(SPI_AUTO_SS) | _BV(SPI_MASTER) | _BV(SPI_INTERRUPT);

    atomic {
      P0MDOUT = 0x0D;                     // Make SCK, MOSI, and NSS push-pull
      P2MDOUT = 0x04;                     // Make the LED push-pull
      
      XBR0 |= 2;                          // Enable the SPI on the XBAR
      XBR1 = 0x40;                        // Enable the XBAR and weak pull-ups

      SPI0CKR   = 0x0;//(SYSCLK/(2*SPI_CLOCK))-1;
      //SPI0CKR   = 0xFF;//(SYSCLK/(2*SPI_CLOCK))-1;

      call SpiControl.setMode(mode); 
      SPIEN = 1;
    }
  }


  command error_t SpiControl.setRate(uint8_t rate) {
    return (FAIL);
  }

  command uint8_t SpiControl.getRate() {
    return (0);
  }

  /*
   * Slave select only works if the SPI unit is in 4-wire, single
   * master mode
   */
  command bool SpiControl.getSlaveSelect() {
    return (NSSMD0);
  }

  command error_t SpiControl.setSlaveSelect(bool select) {
      NSSMD0 = select; // tos.h defines the bool values
      return (SUCCESS);
  }

  command error_t SpiControl.setMode(uint8_t new_mode) {
    uint8_t tmp; 

/*       SPI0CFG   = 0x40; //MSTEN */
/*       SPI0CN    = 0x0D; //4-wire master, SPIEN */

    atomic {
      mode = new_mode;
      tmp = mode & _BV(SPI_4WIRE);
      if(tmp) {
        NSSMD1 = 1;
        NSSMD0 = 1;
      } else {
        NSSMD1 = 0;
      }

      // Set master or slave
      tmp = (mode & _BV(SPI_MASTER)) ? _BV(CIP51_SPI0CFG_MSTEN) : 0;
      SPI0CFG = (SPI0CFG & ~_BV(CIP51_SPI0CFG_MSTEN)) | tmp;

      // Enable SPI interrupt
      ESPI0 = (mode & _BV(SPI_INTERRUPT)) ? 1 : 0;
    }
    return SUCCESS;
  }

  command uint8_t SpiControl.getMode(){
    return(mode);
  }

  async command uint8_t SpiByte.write( uint8_t tx ) {
    uint8_t r = 0;
    // This will generate an iterrupt that will hopefuly be ignored =]
    atomic {
      // Check that a "send" is not running and that bus is free
      if (tx_buf == NULL || NSSMD0==1) { 

        if ( (mode&_BV(SPI_AUTO_SS)) && (mode&_BV(SPI_MASTER)))
          NSSMD0=0;

        SPI0DAT = tx;
        // Wait for data ready
        while(SPIF == 0) {
        }

        if ( (mode&_BV(SPI_AUTO_SS)) && (mode&_BV(SPI_MASTER)))
          NSSMD0=1;

        r = SPI0DAT;
        SPIF = 0;
      }
    }
    return (r);
  }

  async command error_t SpiPacket.send( uint8_t* txBuf,
                                        uint8_t* rxBuf,
                                        uint16_t len ){
    error_t OK = FAIL;
    atomic {
      if (tx_buf == NULL && len > 0) {
        OK = SUCCESS;

        tx_buf_start = txBuf;
        tx_buf = txBuf+1;
        tx_buf_end = txBuf + len;

        rx_buf = rx_buf;
        rx_buf_end = rx_buf+len;

        if ( (mode&_BV(SPI_AUTO_SS)) && (mode&_BV(SPI_MASTER)))
          NSSMD0 = 0;

        SPI0DAT = (*tx_buf_start);
        /**
         * It seems that if we use the outbound double buffer we
         * occationally miss an event indicating an inbound byte
         */

/*         // Fill TX FIFO */
/*         if (len>1) { */
/*           while (TXBMT!= 1) {} // 1st byte moved to shift register */
/*           SPI0DAT = (*tx_buf); */
/*           tx_buf++; */
/*         } */
      }
    }
    return (OK);
  }

  MCS51_INTERRUPT(SIG_SPI0){
    uint8_t done = 0;
    atomic {
      if (tx_buf != NULL) {
        // Send next byte when tx buffer is ready
        // Signal send done when last byte has been completed

        // If an error has occured, signal FAIL, otherwise run the state machine
        if (WCOL || MODF){
          WCOL = 0;
          MODF = 0;
          done=2;
        } else  {
          if (SPIF) {
            (*rx_buf) = SPI0DAT;
            rx_buf++;
          }
          // Signal app when last byte has been received
          if (rx_buf==rx_buf_end) {
            done = 1;
          } else {
            if(tx_buf < tx_buf_end){
              SPI0DAT = (*tx_buf);
              tx_buf++;
            }
          }
        }
        if (done>0) {
          if ( (mode&_BV(SPI_AUTO_SS)) && (mode&_BV(SPI_MASTER)))
            NSSMD0 = 1;

          signal SpiPacket.sendDone(tx_buf_start,                         // txBuf
                                    rx_buf_end-(tx_buf_end-tx_buf_start), // rxBuf
                                    tx_buf-tx_buf_start,                  // Len
                                    done==1?SUCCESS:FAIL);
          tx_buf = NULL;
        }
      }

      // SPI interrupt flag
      if (SPIF) {SPIF = 0;}
      
      if (RXOVRN) {RXOVRN = 0;}
    }

  }
}

