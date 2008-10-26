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
 *
 * @author Marcus Chang <marcus@diku.dk>
 * @author Klaus S. Madsen <klaussm@diku.dk>
 */


module HPLSpiM {
  provides {
    interface Init;
    interface Spi;
  }
}
implementation {

#include "HPLSpi.h"

  MSP430REG_NORACE(P1DIR);
  MSP430REG_NORACE(P1OUT);
  MSP430REG_NORACE(P2OUT);
  MSP430REG_NORACE(P3DIR);
  MSP430REG_NORACE(P3SEL);
  MSP430REG_NORACE(P3OUT);
//  MSP430REG_NORACE(P4DIR);
  MSP430REG_NORACE(U0CTL);
  MSP430REG_NORACE(U0TCTL);
  MSP430REG_NORACE(U0BR1);
  MSP430REG_NORACE(U0BR0);
  MSP430REG_NORACE(U0MCTL);
  MSP430REG_NORACE(ME1);
  MSP430REG_NORACE(IE1);
  MSP430REG_NORACE(IFG1);
  MSP430REG_NORACE(U0TXBUF);


    void bus_spi_init(bus_spi_flags flags);
    uint8_t bus_spi_exchange(uint8_t out);
    bool isSPI();

    norace uint8_t oldPrameters, oldId;


    command error_t Init.init() {

        /* spi enable */
        P2OUT |= 0xF0; /*module select none*/
        bus_spi_init(BUS_STE + BUS_PHASE_INVERT);
        
        P2OUT &= 0xE0; /*module select RF*/

        P3OUT |= 0x01;
        bus_spi_exchange((uint8_t) 0x10 & 0x3F);
        bus_spi_exchange((uint8_t) 0x00);
        bus_spi_exchange((uint8_t) 0x00);
        P3OUT &= ~0x01;

        P3OUT |= 0x01;
        bus_spi_exchange((uint8_t) 0x10 & 0x3F);
        bus_spi_exchange((uint8_t) 0xF8);
        bus_spi_exchange((uint8_t) 0x01);
        P3OUT &= ~0x01;

        P3OUT |= 0x01;
        bus_spi_exchange((uint8_t) 0x06);
        P3OUT &= ~0x01;

        /* spi disable */
//        P4DIR = 0;  /*parport input mode*/
        P3DIR &= ~0x3F; /*bus pins input*/
        P3SEL &= ~0x3F; /*turn module i/o off*/
        ME1 &= ~(UTXE0 | URXE0 | USPIE0); /* Modules off */
        P2OUT |= 0xF0; /*module select none*/
        
        
        /* Setup crystal oscillator control */
        call Spi.enable(BUS_CLOCK_1MHZ, 0);
        P1DIR |= 0x40;           /*This pin is used as OSC_DISABLE*/
        P1OUT |= 0x40;           /*That is, 0 means clock is on, 1 disabled*/
        call Spi.write((uint8_t) 0xBF);  /*Select P1.4-6 as PLD controls*/
        call Spi.disable();

        return SUCCESS;
    }

    /**
    * Enable the SPI bus functionality
    */
    async command error_t Spi.enable(uint8_t newPrameters, uint8_t newId) {

        if(isSPI() && (newPrameters == oldPrameters) && (newId == oldId) ) 
            return SUCCESS;

        oldPrameters = newPrameters;
        oldId = newId;

        bus_spi_init((bus_spi_flags) newPrameters);
        TOSH_uwait(3);
        P2OUT = (P2OUT & 0x0F)| (newId << 4);

        return SUCCESS;
    }

    /**
    * Disable the SPI bus functionality
    */
    async command error_t Spi.disable() {
    
        P2OUT |= 0xF0; /*module select none*/
//        P4DIR = 0;  /*parport input mode*/
        P3DIR &= ~0x3F; /*bus pins input*/
        P3SEL &= ~0x3F; /*turn module i/o off*/
        ME1 &= ~(UTXE0 | URXE0 | USPIE0); /* Modules off */

        return SUCCESS;
    }

    /**
    * Write a byte to the SPI bus
    * @param data value written to the MOSI pin
    * @return value read on the MISO pin
    */
    async command uint8_t Spi.write(uint8_t data) {

        return bus_spi_exchange(data);
    }


    /**
     * Bus SPI check.
     *
     */
    bool isSPI() {
        bool _ret = FALSE;
        
        atomic{
            if (ME1 & USPIE0)
                _ret = TRUE;
        }
        
        return _ret;
    }

    /**
     * Bus SPI init.
     *
     * \param flags SPI mode flags
     *
     * \return pdTRUE
     * \return pdFALSE  bus reserved
     */
    void bus_spi_init(bus_spi_flags flags)
    {

        P3DIR &= ~0x30; /*UART pins inputs*/
        P3SEL &= ~0x30; /*UART pins GPIO*/

        if (flags & (bus_spi_flags)BUS_SPI_SLAVE)
        {
            return;
        }
        else
        {
            uint8_t tctl_bits = STC;

            P3SEL |= 0x0E; /*MISO,MOSI,UCLK used*/
            P3SEL &= ~0x01; /*STE = GPIO*/
            P3DIR |= 0x0B;  /*MOSI, STE and UCLK out*/
            if (flags & (bus_spi_flags)BUS_STE)
            {
                P3OUT |= 0x01;
            }
            else
            {
                P3OUT &= ~0x01;
            }
            P3DIR &= ~0x04; /*MISO in*/
            /* Reset UART. */
            U0CTL = SWRST;

            /* SPI master, 8 bit. */
            U0CTL |= SYNC+MM+CHAR;
            if (flags & (bus_spi_flags)BUS_PHASE_INVERT)
            {
                tctl_bits |= CKPH;
            }
            if (flags & (bus_spi_flags)BUS_CLOCK_INVERT)
            {
                tctl_bits |= CKPL;
            }
            tctl_bits |= SSEL1; /*Use SMCLK*/
            if (flags & (bus_spi_flags)BUS_MULTIMASTER)
            {
                tctl_bits &= ~STC;
            }

            U0TCTL = tctl_bits;

            switch (flags & 0x70)
            {
                case BUS_CLOCK_115kHZ:
                    if (SPI_115K >= 2)
                    {
                        U0BR1 = (SPI_115K >> 8);
                        U0BR0 = SPI_115K;
                    }
                    else
                    {
                        U0BR1 = 0;
                        U0BR0 = 2;
                    }
                    break;

                case BUS_CLOCK_1MHZ:
                    if (SPI_1M >= 2)
                    {
                        U0BR1 = (SPI_1M >> 8);
                        U0BR0 = SPI_1M;
                    }
                    else
                    {
                        U0BR1 = 0;
                        U0BR0 = 2;
                    }
                    break;

                case BUS_CLOCK_4MHZ:
                default:    /*Maximum speed*/
                    U0BR1 = 0;
                    U0BR0 = 2;
                    break;
            }

            U0MCTL = 0;

            /* Set ports. */
            ME1 &= ~(UTXE0 + URXE0);
            ME1 |= USPIE0;

            /* Set. */
            U0CTL &= ~SWRST;

            /* Disable interrupts. */
            IE1 &= ~ (URXIE0 + UTXIE0);

        }
    }



    /**
     * Bus SPI exchange.
     *
     * \param out byte to transmit
     *
     * \return byte from SPI
     */
    uint8_t bus_spi_exchange(uint8_t out)
    {
        U0TXBUF = out;
        while(!(IFG1 & URXIFG0));
        return U0RXBUF; 
    }

}
