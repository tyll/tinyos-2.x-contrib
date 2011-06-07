/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 
/**
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 

/* modified for Robbie's new SDRAM section
 * RMK
 */

 
#ifndef _SDRAM_H_
#define _SDRAM_H_

#define VGA_SIZE_RGB (640*480*2)
#define QVGA_SIZE_YUV (320*240*2)
#define DPCM_SIZE (320*240)

uint32_t base_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));
uint32_t jpeg_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));
uint32_t buf1_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));
uint32_t buf2_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));
uint32_t buf3_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));

#define BASE_FRAME_ADDRESS	base_f
#define JPEG_FRAME_ADDRESS	jpeg_f
#define BUF1_FRAME_ADDRESS	buf1_f
#define BUF2_FRAME_ADDRESS	buf2_f
#define BUF3_FRAME_ADDRESS	buf3_f



/*
* DPCM Structures
*/
// blocco buffer 1
uint32_t base1_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));
uint32_t dpcm1_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));

#define BASE1_FRAME_ADDRESS	base1_f
#define DPCM1_FRAME_ADDRESS	dpcm1_f

// blocco buffer 2
uint32_t base2_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));
uint32_t dpcm2_f[VGA_SIZE_RGB] __attribute__((section(".sdram")));

#define BASE2_FRAME_ADDRESS	base2_f
#define DPCM2_FRAME_ADDRESS	dpcm2_f


// blocco buffer 3
uint32_t base3_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm3_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE3_FRAME_ADDRESS	base3_f
#define DPCM3_FRAME_ADDRESS	dpcm3_f

// blocco buffer 4
uint32_t base4_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm4_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE4_FRAME_ADDRESS	base4_f
#define DPCM4_FRAME_ADDRESS	dpcm4_f
/*
// blocco buffer 5
uint32_t base5_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm5_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE5_FRAME_ADDRESS	base5_f
#define DPCM5_FRAME_ADDRESS	dpcm5_f
// blocco buffer 6
uint32_t base6_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm6_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE6_FRAME_ADDRESS	base6_f
#define DPCM6_FRAME_ADDRESS	dpcm6_f
// blocco buffer 7
uint32_t base7_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm7_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE7_FRAME_ADDRESS	base7_f
#define DPCM7_FRAME_ADDRESS	dpcm7_f
// blocco buffer 8
uint32_t base8_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm8_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE8_FRAME_ADDRESS	base8_f
#define DPCM8_FRAME_ADDRESS	dpcm8_f
// blocco buffer 9
uint32_t base9_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm9_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE9_FRAME_ADDRESS	base9_f
#define DPCM9_FRAME_ADDRESS	dpcm9_f
// blocco buffer 10
uint32_t base10_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm10_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE10_FRAME_ADDRESS	base10_f
#define DPCM10_FRAME_ADDRESS	dpcm10_f

// blocco buffer 11
uint32_t base11_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm11_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE11_FRAME_ADDRESS	base11_f
#define DPCM11_FRAME_ADDRESS	dpcm11_f

// blocco buffer 12
uint32_t base12_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm12_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE12_FRAME_ADDRESS	base12_f
#define DPCM12_FRAME_ADDRESS	dpcm12_f
// blocco buffer 13
uint32_t base13_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm13_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE13_FRAME_ADDRESS	base13_f
#define DPCM13_FRAME_ADDRESS	dpcm13_f

// blocco buffer 14
uint32_t base14_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm14_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE14_FRAME_ADDRESS	base14_f
#define DPCM14_FRAME_ADDRESS	dpcm14_f
// blocco buffer 15
uint32_t base15_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm15_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE15_FRAME_ADDRESS	base15_f
#define DPCM15_FRAME_ADDRESS	dpcm15_f

// blocco buffer 16
uint32_t base16_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm16_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE16_FRAME_ADDRESS	base16_f
#define DPCM16_FRAME_ADDRESS	dpcm16_f

// blocco buffer 17
uint32_t base17_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm17_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE17_FRAME_ADDRESS	base17_f
#define DPCM17_FRAME_ADDRESS	dpcm17_f

// blocco buffer 18
uint32_t base18_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm18_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE18_FRAME_ADDRESS	base18_f
#define DPCM18_FRAME_ADDRESS	dpcm18_f

// blocco buffer 19
uint32_t base19_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm19_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE19_FRAME_ADDRESS	base19_f
#define DPCM19_FRAME_ADDRESS	dpcm19_f

// blocco buffer 20
uint32_t base20_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));
uint32_t dpcm20_f[QVGA_SIZE_YUV] __attribute__((section(".sdram")));


#define BASE20_FRAME_ADDRESS	base20_f
#define DPCM20_FRAME_ADDRESS	dpcm20_f
*/
#endif //_SDRAM_H_
