/*
 * Copyright (c) 2005 Arch Rock Corporation 
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of the Arch Rock Corporation nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 *
 * @author Kaisen Lin
 * @author Phil Buonadonna
 */
/**
 * Adapted for nxtmote.
 * @author Rasmus Ulslev Pedersen
 */
#include "SPI.h"

module HalAT91SPIControlP {
  provides interface HalAT91SPICntl;

  uses interface HplAT91SPI as SPI;
}

implementation {

  command error_t HalAT91SPICntl.setSPIParams() {
		*AT91C_PMC_PCER             = (1L << AT91C_ID_SPI);       /* Enable MCK clock     */\
		*AT91C_PIOA_PER             = AT91C_PIO_PA12;             /* Enable A0 on PA12    */\
		*AT91C_PIOA_OER             = AT91C_PIO_PA12;\
		*AT91C_PIOA_CODR            = AT91C_PIO_PA12;\
		*AT91C_PIOA_PDR             = AT91C_PA14_SPCK;            /* Enable SPCK on PA14  */\
		*AT91C_PIOA_ASR             = AT91C_PA14_SPCK;\
		*AT91C_PIOA_ODR             = AT91C_PA14_SPCK;\
		*AT91C_PIOA_OWER            = AT91C_PA14_SPCK;\
		*AT91C_PIOA_MDDR            = AT91C_PA14_SPCK;\
		*AT91C_PIOA_PPUDR           = AT91C_PA14_SPCK;\
		*AT91C_PIOA_IFDR            = AT91C_PA14_SPCK;\
		*AT91C_PIOA_CODR            = AT91C_PA14_SPCK;\
		*AT91C_PIOA_IDR             = AT91C_PA14_SPCK;\
		*AT91C_PIOA_PDR             = AT91C_PA13_MOSI;            /* Enable mosi on PA13  */\
		*AT91C_PIOA_ASR             = AT91C_PA13_MOSI;\
		*AT91C_PIOA_ODR             = AT91C_PA13_MOSI;\
		*AT91C_PIOA_OWER            = AT91C_PA13_MOSI;\
		*AT91C_PIOA_MDDR            = AT91C_PA13_MOSI;\
		*AT91C_PIOA_PPUDR           = AT91C_PA13_MOSI;\
		*AT91C_PIOA_IFDR            = AT91C_PA13_MOSI;\
		*AT91C_PIOA_CODR            = AT91C_PA13_MOSI;\
		*AT91C_PIOA_IDR             = AT91C_PA13_MOSI;\
		*AT91C_PIOA_PDR             = AT91C_PA10_NPCS2;           /* Enable npcs0 on PA11  */\
		*AT91C_PIOA_BSR             = AT91C_PA10_NPCS2;\
		*AT91C_PIOA_ODR             = AT91C_PA10_NPCS2;\
		*AT91C_PIOA_OWER            = AT91C_PA10_NPCS2;\
		*AT91C_PIOA_MDDR            = AT91C_PA10_NPCS2;\
		*AT91C_PIOA_PPUDR           = AT91C_PA10_NPCS2;\
		*AT91C_PIOA_IFDR            = AT91C_PA10_NPCS2;\
		*AT91C_PIOA_CODR            = AT91C_PA10_NPCS2;\
		*AT91C_PIOA_IDR             = AT91C_PA10_NPCS2;\
		*AT91C_SPI_CR               = AT91C_SPI_SWRST;            /* Soft reset           */\
		*AT91C_SPI_CR               = AT91C_SPI_SPIEN;            /* Enable spi           */\
		*AT91C_SPI_MR               = AT91C_SPI_MSTR  | AT91C_SPI_MODFDIS | (0xB << 16);\
		AT91C_SPI_CSR[2]              = ((OSC / SPI_BITRATE) << 8) | AT91C_SPI_CPOL;\

    return SUCCESS;
  }

  async event void SPI.interruptSPI() {
  }
}
