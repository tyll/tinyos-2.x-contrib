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
*   from this software without specific prior written permission.
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
 * @brief Driver module for the OmniVision OV7649 Camera
 * @author
 *		Andrew Barton-Sweeney (abs@cs.yale.edu)
 *		Evan Park (evanpark@gmail.com)
 */
/**
 * @brief Ported to TOS2
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 
#ifndef _OV7649_H
#define _OV7649_H

#define MAX_OV7649_REG	0x80

#define ENABLE	1
#define DISABLE	0
#define OVWRITE	0x42
#define OVREAD	0x43

#define GAIN	0x00
#define BLUE	0x01
#define RED		0x02
#define SAT		0x03
#define HUE		0x04
#define CWF		0x05
#define BRT		0x06

#define PID		0x0A
#define VER		0x0B
#define AECH	0x10

#define CLKRC	0x11	// HSYNC polarity
#define COMA	0x12
#define COMB	0x13
#define COMC	0x14	// resolution and HREF polarity
#define COMD	0x15	// ydata and pclk polarity
#define REG16	0x16

#define PSHFT	0x1B	// pixel delay after href

#define REG1E	0x1E
#define FACT	0x1F	// rgb format control

#define COMF	0x26	// byte-oder in ydata
#define COMG	0x27
#define COMH	0x28
#define FRARH	0x2A	// FRA[9:0] = FRARH[6:5](msb) + FRARL[7:0](lsb)
#define FRARL	0x2B
#define COMJ	0x2D

#define RMCO	0x6C
#define GMCO	0x6D
#define BMCO	0x6E
#define COML	0x71	// gate PCLK with HREF and set HSYNC delay msb
#define HSDYR	0x72	// HSYNC rising edge delay lsb
#define HSDYF	0x73	// HSYNC falling edge delay lsb ( 0 to 762 pixel delays )
#define COMM	0x74
#define COMN	0x75	// vertical flip enable
#define REG79	0x79	//! This is reserved, but mentioned in the OVT Effects document (for OV7640 ?)
#define REG7A	0x7A	//! This is reserved, but mentioned in the OVT Effects document

#define HSTRT	0x17
#define HSTOP	0x18
#define VSTRT	0x19
#define VSTOP	0x1A

typedef struct {
	uint8_t config;
}  __attribute__ ((packed)) ov_config_t;

typedef struct {
	uint8_t color;
	uint8_t config;
	uint8_t stat;
}  __attribute__ ((packed)) ov_stat_t;

enum {
	COLOR_RGB565_XYZ,
	COLOR_UYVY_XYZ,
	COLOR_RGB565,
	COLOR_UYVY,
	COLOR_8BITGRAY,
	COLOR_1BITBW,
}; 

enum {
	OV_CONFIG_YUV,
	OV_CONFIG_RGB,
};

enum {
	//OV_STAT_IDLE	= 0x00,
	OV_STAT_CAPTURE	= 0x01,
	OV_STAT_PROCESS	= 0x02,
	OV_STAT_ERROR	= 0x04,
	OV_STAT_FLIP	= 0x10,
};

#define OV_STAT_FLIP_BIT	OV_STAT_FLIP

#define PWDN_INTERVAL		1024
#define RESET_INTERVAL		1024
#define CRYSTAL_INTERVAL	4096

#endif /* _OV7649_H */
