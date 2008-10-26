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


#ifndef _H_HPLSpi_h
#define _H_HPLSpi_h

#define SPI_RESOURCE "SPI.Resource"

#define configCPU_CLOCK_HZ	( ( unsigned long ) 8000000 )

#ifndef configSMCLK_HZ
#define SPI_115K  (configCPU_CLOCK_HZ / 115200)
#define SPI_1M  (configCPU_CLOCK_HZ / 1000000)
#define SPI_4M  (configCPU_CLOCK_HZ / 4000000)
#else
#define SPI_115K  (configSMCLK_HZ / 115200)
#define SPI_1M  (configSMCLK_HZ / 1000000)
#define SPI_4M  (configSMCLK_HZ / 4000000)
#endif

	typedef enum
	{
		BUS_SPI_DEFAULT = 0x00,
		BUS_STE = 0x01,
		BUS_PHASE_INVERT = 0x02,
		BUS_CLOCK_INVERT = 0x04,
		BUS_MULTIMASTER = 0x08,
		BUS_CLOCK_115kHZ = 0x20,
		BUS_CLOCK_1MHZ = 0x40,
		BUS_CLOCK_4MHZ = 0x60,
		BUS_SPI_SLAVE = 0x80
	}bus_spi_flags;



#endif//_H_HPLSpi_h
