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
 /**
 * HplOV7649P is the driver for the OV7649. 
 *  It requires an SCCB interface and provides the 
 * OV7649 HPL interface.
 */

#include "OV7649.h"
//#include "SCCB.h"


module HplOV7649M
{
  provides interface HplOV7649;
  provides interface HplOV7649Advanced;

  uses interface Leds;
  uses interface HplSCCB as Sccb_OVWRITE;
  uses interface GeneralIO as LED;
  uses interface GeneralIO as PWDN;
  uses interface GeneralIO as RESET;
  uses interface GeneralIO as SIOD;
  uses interface GeneralIO as SIOC;
}

implementation {

	/*
	 *	OV7649 Driver State
	 *
	 */
	
	ov_stat_t global_stat;
	
	/**
	 * (Busy) wait <code>usec</code> microseconds
	 */
	inline void TOSH_uwait(uint16_t usec)
	{
	  uint32_t start,mark = usec;
	
	  //in order to avoid having to reset OSCR0, we need to look at time differences
	
	  start = OSCR0;
	  mark <<= 2;
	  mark *= 13;
	  mark >>= 2;
	
	  //OSCR0-start should work correctly due to nice properties of underflow
	  while ( (OSCR0 - start) < mark);
	}
	
	command uint8_t HplOV7649Advanced.max_reg_addr()
	{
		return MAX_OV7649_REG;
	}
	
	command uint8_t HplOV7649Advanced.get_reg_val(uint8_t addr)
	{
		uint8_t val;
		call Sccb_OVWRITE.two_write(addr);
		call Sccb_OVWRITE.read(&val);	// Check return status ??
	
		return val;
	}
	
	command uint8_t HplOV7649Advanced.set_reg_val(uint8_t addr, uint8_t reg_val)
	{
		call Sccb_OVWRITE.three_write(reg_val, addr);
	
		return call HplOV7649Advanced.get_reg_val(addr);
	}
	
	command ov_stat_t HplOV7649Advanced.get_ov_stat()
	{
		return global_stat;
	}
	
	command error_t HplOV7649.set_config(ov_config_t *config)
	{
		call HplOV7649.soft_reset();
		switch (config->config) 
		{
			case OV_CONFIG_YUV: 
			{
				call HplOV7649.config_yuv();
				break;
			}
			case OV_CONFIG_RGB: 
			{
				call HplOV7649.config_rgb();
				break;
			}
			default:
				return FAIL;
		}
		return SUCCESS;
	}
	
	command error_t HplOV7649.init(uint8_t color)
	{
		led_out();//call LED.makeOutput();
		atomic{	
			call HplOV7649.hardware_init();
			call HplOV7649.hard_reset();
			call HplOV7649.soft_reset();
	
			if (color == COLOR_RGB565) 
				call HplOV7649.config_rgb();
			else 
				call HplOV7649.config_yuv();
		}
		return SUCCESS;
	}
	
	command void HplOV7649.hardware_init()
	{
		pwdn_out();//call PWDN.makeOutput();
		reset_out();//call RESET.makeOutput();
		sdata_out();//call SIOD.makeOutput(); // done by SCCB
		sclock_out();//call SIOC.makeOutput();
	}
	
	command void HplOV7649.hard_reset()
	{
		pwdn_set();//call PWDN.set(); 			// Turn off the camera - PWDN is active high
		reset_clr();//call RESET.clr();			// lower the hardware reset signal - RESET is active high
		TOSH_uwait(PWDN_INTERVAL);
	
		pwdn_clr();//call PWDN.clr(); 			// Turn on the camera
		reset_set();//call RESET.set();			// raise the hardware reset signal
		TOSH_uwait(RESET_INTERVAL);
	
		reset_clr();//call RESET.clr();			// lower the hardware reset signal
		TOSH_uwait(CRYSTAL_INTERVAL);
	}
	
	command void HplOV7649.soft_reset()
	{
		call Sccb_OVWRITE.init(); //this component is wired to OVWRITE
		call Sccb_OVWRITE.three_write(0x80,COMA);		//! Software Reset the Camera
		TOSH_uwait(CRYSTAL_INTERVAL);	// wait for camera to settle
		call Sccb_OVWRITE.three_write(0x24,COMC); 	// QVGA
		call Sccb_OVWRITE.three_write(0x40,COML);	// gate PCLK with HREF
	}
	
	command void HplOV7649.config_yuv()
	{
		// BW IMAGE
		call Sccb_OVWRITE.three_write(0x04,SAT);
		call Sccb_OVWRITE.three_write(0xFF,RMCO);
		call Sccb_OVWRITE.three_write(0xFF,GMCO);
		call Sccb_OVWRITE.three_write(0xFF,BMCO);
		// NORMAL LIGHT
		call Sccb_OVWRITE.three_write(0x60,BRT);
		global_stat.config = OV_CONFIG_YUV;
		global_stat.color = COLOR_UYVY;
	}
	
	command void HplOV7649.config_rgb()
	{
		call Sccb_OVWRITE.three_write(0x11,FACT); 	// RGB 565
		call Sccb_OVWRITE.three_write(0x1C,COMA); 	// RGB output, enable AWB
		global_stat.config = OV_CONFIG_RGB;
		global_stat.color = COLOR_RGB565;
	}

	command void HplOV7649.config_window(uint8_t hstrt, uint8_t hstop, uint8_t vstrt, uint8_t vstop)
	{
		call Sccb_OVWRITE.three_write(hstrt,HSTRT);
		call Sccb_OVWRITE.three_write(hstop,HSTOP);
		call Sccb_OVWRITE.three_write(vstrt,VSTRT);
		call Sccb_OVWRITE.three_write(vstop,VSTOP);
	}
	
	async command ov_stat_t *HplOV7649.get_config()
	{
		return &global_stat;
	}
}
