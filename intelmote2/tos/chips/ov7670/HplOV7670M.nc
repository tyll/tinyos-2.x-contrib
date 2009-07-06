/*
* Copyright (c) 2008 Stanford University. All rights reserved.
* This file may be distributed under the terms of the GNU General
* Public License, version 2.
*/
/**
 * @brief Driver module for the OmniVision OV7670 Camera, inspired by V4L2
 *        linux driver for OV7670.
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */

#include "OV7670.h"
#include "SCCB.h"

#define VGA 1

module HplOV7670M
{
  provides interface HplOV7670;
  provides interface HplOV7670Advanced;

  uses interface Leds;
  uses interface HplSCCB as Sccb_OVWRITE;
  uses interface GeneralIO as LED;
  uses interface GeneralIO as PWDN;
  uses interface GeneralIO as RESET;
  uses interface GeneralIO as SIOD;
  uses interface GeneralIO as SIOC;
}

implementation {

	ov_stat_t global_stat;

/* YCbCr, VGA * 15fps @ 24MHz input clock
 */
uint8_t init_array_vga[][2] = {
  { 0x11, 0x03 },
}; /*
  { 0x3a, 0x04 },
  { 0x12, 0x00 },
	{ 0x17, 0x13 },
	{ 0x18, 0x01 },
	{ 0x32, 0xb6 },
	{ 0x19, 0x02 },
	{ 0x1a, 0x7a },
	{ 0x03, 0x0a },
	{ 0x0c, 0x00 },
	{ 0x3e, 0x00 },
	{ 0x70, 0x3a },
	{ 0x71, 0x35 },
	{ 0x72, 0x11 },
	{ 0x73, 0xf0 },
	{ 0xa2, 0x02 },

	{ 0x7a, 0x20 },
	{ 0x7b, 0x10 },
	{ 0x7c, 0x1e },
	{ 0x7d, 0x35 },
	{ 0x7e, 0x5a },
	{ 0x7f, 0x69 },
	{ 0x80, 0x76 },
	{ 0x81, 0x80 },
	{ 0x82, 0x88 },
	{ 0x83, 0x8f },
	{ 0x84, 0x96 },
	{ 0x85, 0xa3 },
	{ 0x86, 0xaf },
	{ 0x87, 0xc4 },
	{ 0x88, 0xd7 },
	{ 0x89, 0xe8 },

	{ 0x13, 0xe0 },
	{ 0x00, 0x00 },
	{ 0x10, 0x00 },
	{ 0x0d, 0x40 },
	{ 0x14, 0x18 },
	{ 0xa5, 0x05 },
	{ 0xab, 0x07 },
	{ 0x24, 0x95 },
	{ 0x25, 0x33 },
	{ 0x26, 0xe3 },
	{ 0x9f, 0x78 },
	{ 0xa0, 0x68 },
	{ 0xa1, 0x03 },
	{ 0xa6, 0xd8 },
	{ 0xa7, 0xd8 },
	{ 0xa8, 0xf0 },
	{ 0xa9, 0x90 },
	{ 0xaa, 0x94 },
	{ 0x13, 0xe5 },

	{ 0x0e, 0x61 },
	{ 0x0f, 0x4b },
	{ 0x16, 0x02 },
	{ 0x1e, 0x07 },
	{ 0x21, 0x02 },
	{ 0x22, 0x91 },
	{ 0x29, 0x07 },
	{ 0x33, 0x0b },
	{ 0x35, 0x0b },
	{ 0x37, 0x1d },
	{ 0x38, 0x71 },
	{ 0x39, 0x2a },
	{ 0x3c, 0x78 },
	{ 0x4d, 0x40 },
	{ 0x4e, 0x20 },
	{ 0x69, 0x00 },
	{ 0x6b, 0x4a },
	{ 0x74, 0x10 },
	{ 0x8d, 0x4f },
	{ 0x8e, 0x00 },
	{ 0x8f, 0x00 },
	{ 0x90, 0x00 },
	{ 0x91, 0x00 },
	{ 0x96, 0x00 },
	{ 0x9a, 0x80 },
	{ 0xb0, 0x84 },
	{ 0xb1, 0x0c },
	{ 0xb2, 0x0e },
	{ 0xb3, 0x82 },
	{ 0xb8, 0x0a },

	{ 0x43, 0x0a },
	{ 0x44, 0xf0 },
	{ 0x45, 0x34 },
	{ 0x46, 0x58 },
	{ 0x47, 0x28 },
	{ 0x48, 0x3a },
	{ 0x59, 0x88 },
	{ 0x5a, 0x88 },
	{ 0x5b, 0x44 },
	{ 0x5c, 0x67 },
	{ 0x5d, 0x49 },
	{ 0x5e, 0x0e },
	{ 0x6c, 0x0a },
	{ 0x6d, 0x55 },
	{ 0x6e, 0x11 },
	{ 0x6f, 0x9f }, // 9e
	{ 0x6a, 0x40 },
	{ 0x01, 0x40 },
	{ 0x02, 0x40 },
	{ 0x13, 0xe7 },

	{ 0x4f, 0x80 },
	{ 0x50, 0x80 },
	{ 0x51, 0x00 },
	{ 0x52, 0x22 },
	{ 0x53, 0x5e },
	{ 0x54, 0x80 },
	{ 0x58, 0x9e },

	{ 0x41, 0x08 },
	{ 0x3f, 0x00 },
	{ 0x75, 0x05 },
	{ 0x76, 0xe1 },
	{ 0x4c, 0x00 },
	{ 0x77, 0x01 },
	{ 0x3d, 0xc2 },
	{ 0x4b, 0x09 },
	{ 0xc9, 0x60 },
	{ 0x41, 0x38 },
	{ 0x56, 0x40 },

	{ 0x34, 0x11 },
	{ 0x3b, 0x02 },
	{ 0xa4, 0x88 },
	{ 0x96, 0x00 },
	{ 0x97, 0x30 },
	{ 0x98, 0x20 },
	{ 0x99, 0x30 },
	{ 0x9a, 0x84 },
	{ 0x9b, 0x29 },
	{ 0x9c, 0x03 },
	{ 0x9d, 0x4c },
	{ 0x9e, 0x3f },
	{ 0x78, 0x04 },
	}; */

	
	/**
	 * (Busy) wait <code>usec</code> microseconds
	 */
	inline void TOSH_uwait(uint32_t usec)
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
	
	command uint8_t HplOV7670Advanced.get_reg_val(uint8_t addr)
	{
		uint8_t val;
		call Sccb_OVWRITE.two_write(addr);
		call Sccb_OVWRITE.read(&val);	// Check return status ??
	
		return val;
	}
	
	command uint8_t HplOV7670Advanced.set_reg_val(uint8_t addr, uint8_t reg_val)
	{
		call Sccb_OVWRITE.three_write(reg_val, addr);
	
		return call HplOV7670Advanced.get_reg_val(addr);
	}
	
	command ov_stat_t HplOV7670Advanced.get_ov_stat()
	{
		return global_stat;
	}
	/*	
	command error_t HplOV7670.set_config(ov_config_t *config)
	{
		call HplOV7670.soft_reset();
		switch (config->config) 
		{
			case OV_CONFIG_YUV: 
			{
				call HplOV7670.config_yuv();
				break;
			}
			case OV_CONFIG_RGB: 
			{
				call HplOV7670.config_rgb();
				break;
			}
			default:
				return FAIL;
		}
		return SUCCESS;
	}
	*/
	command error_t HplOV7670.init(uint8_t color, uint8_t type, uint8_t size)
	{
		led_out();//call LED.makeOutput();
		atomic {
		  if (type == 0) {
			call HplOV7670.hardware_init();
			call HplOV7670.hard_reset();
			call HplOV7670.soft_reset();
		}
			if (color == COLOR_RGB565) 
				call HplOV7670.config_rgb(size);
			else 
				call HplOV7670.config_yuv(size);
		}
		TOSH_uwait(300000); // wait to settle...
		return SUCCESS;
	}
	
	command void HplOV7670.hardware_init()
	{
		pwdn_out();//call PWDN.makeOutput();
		reset_out();//call RESET.makeOutput();
		sdata_out();//call SIOD.makeOutput(); // done by SCCB
		sclock_out();//call SIOC.makeOutput();
	}
	
	command void HplOV7670.hard_reset()
	{
		pwdn_set();//call PWDN.set(); 			// Turn off the camera - PWDN is active high
		//reset_clr();//call RESET.clr();			// lower the hardware reset signal - RESET is active high
		reset_set();
		TOSH_uwait(PWDN_INTERVAL);
	
		pwdn_clr();//call PWDN.clr(); 			// Turn on the camera
		//reset_set();//call RESET.set();			// raise the hardware reset signal
		reset_clr();
		TOSH_uwait(RESET_INTERVAL);
	
		//reset_clr();//call RESET.clr();			// lower the hardware reset signal
		reset_set();
		TOSH_uwait(CRYSTAL_INTERVAL);
	}
	
	command void HplOV7670.soft_reset() {
	  call Sccb_OVWRITE.init(); //this component is wired to OVWRITE
	  call Sccb_OVWRITE.three_write(COM7_RESET,REG_COM7); // Software Reset the Camera
	  TOSH_uwait(CRYSTAL_INTERVAL);	// wait for camera to settle
	  // call Sccb_OVWRITE.three_write(0x40, COML);	// gate PCLK with HREF
	  // call Sccb_OVWRITE.three_write(COM10_PCLK_HB, REG_COM10); // gate PCLK with HREF
	  call Sccb_OVWRITE.three_write(0x03, 0x11); // CLKRC
	  /* read test
	     {
	     int i;
	     i = call HplOV7670Advanced.get_reg_val(0x0A);
	     i = i + 1;
	     }
	  */
	}
	
	command void HplOV7670.config_yuv(uint8_t size) {
	  int i, j;

	  if (size == SIZE_VGA) {
	    call Sccb_OVWRITE.three_write(COM7_FMT_VGA, REG_COM7); // VGA
	  } else {
	    call Sccb_OVWRITE.three_write(COM7_FMT_QVGA, REG_COM7); // QVGA
	  }
	  // BW IMAGE
	  //call Sccb_OVWRITE.three_write(COM7_FMT_QVGA, REG_COM7); 	// select YUV
	  //call Sccb_OVWRITE.three_write(0,REG_RGB444); 	// no RGB 444
	  //call Sccb_OVWRITE.three_write(0,REG_COM1); 	//
	  //call Sccb_OVWRITE.three_write(COM15_R00FF,REG_COM15); 	//
	  //call Sccb_OVWRITE.three_write(0x18,REG_COM9); /* 4x gain ceiling; 0x8 is reserved bit */
	  //call Sccb_OVWRITE.three_write(0x80,0x4f);
	  //call Sccb_OVWRITE.three_write(0x80,0x50);
	  //call Sccb_OVWRITE.three_write(0,0x51);
	  //call Sccb_OVWRITE.three_write(0x22,0x52);
	  //call Sccb_OVWRITE.three_write(0x5e,0x53);
	  //call Sccb_OVWRITE.three_write(0x80,0x54);
	  //call Sccb_OVWRITE.three_write(COM13_GAMMA|COM13_UVSAT,REG_COM13);

	  /*
	  j = (sizeof(init_array_vga) / sizeof(init_array_vga[0]));
	  for (i = 0; i < j; i++) {
	    call Sccb_OVWRITE.three_write(init_array_vga[i][1], init_array_vga[i][0]); // val, reg
	  }
	  */
	  /* test pattern
	  call Sccb_OVWRITE.three_write(0x3A, 0x70);
	  call Sccb_OVWRITE.three_write(0xB5, 0x71);
	  */
	  global_stat.config = OV_CONFIG_YUV;
	  global_stat.color = COLOR_UYVY;
	}
	
	command void HplOV7670.config_rgb(uint8_t size)
	{
		//call Sccb_OVWRITE.three_write(0x11,FACT); 	// RGB 565
	  if (size == SIZE_VGA) {
	    call Sccb_OVWRITE.three_write(COM7_RGB | COM7_FMT_VGA, REG_COM7);
	  } else { // QVGA
	    call Sccb_OVWRITE.three_write(COM7_RGB | COM7_FMT_QVGA, REG_COM7);
	  }
	  call Sccb_OVWRITE.three_write(0,REG_RGB444); 	// RGB 565
	  call Sccb_OVWRITE.three_write(COM15_RGB565,REG_COM15); 	// RGB 565

	  //call Sccb_OVWRITE.three_write(0xb3,0x4f);
	  //call Sccb_OVWRITE.three_write(0xb3,0x50);
	  //call Sccb_OVWRITE.three_write(0,0x51);
	  //call Sccb_OVWRITE.three_write(0x3d,0x52);
	  //call Sccb_OVWRITE.three_write(0xa7,0x53);
	  //call Sccb_OVWRITE.three_write(0xe4,0x54);
	  //call Sccb_OVWRITE.three_write(COM13_GAMMA|COM13_UVSAT|0x2,REG_COM13);
	  /* test pattern
	  call Sccb_OVWRITE.three_write(0x3A, 0x70);
	  call Sccb_OVWRITE.three_write(0xB5, 0x71);
	  */

	  global_stat.config = OV_CONFIG_RGB;
	  global_stat.color = COLOR_RGB565;
	}

	command void HplOV7670.config_window(uint8_t size) {

	  /*
	  call Sccb_OVWRITE.three_write(hstrt >> 3, REG_HSTART);
	  call Sccb_OVWRITE.three_write(hstop >> 3, REG_HSTOP);
	  call Sccb_OVWRITE.three_write(0x80 | ((hstop&0x07) << 3) | (hstrt & 0x07), REG_HREF);
	  call Sccb_OVWRITE.three_write(vstrt >> 2, REG_VSTART);
	  call Sccb_OVWRITE.three_write(vstop >> 2, REG_VSTOP);
	  call Sccb_OVWRITE.three_write(((vstop & 0x03) << 2) | (vstrt & 0x03), REG_VREF);
	  */
	  if (size == SIZE_VGA) {
	    call Sccb_OVWRITE.three_write(0x13, 0x17); // HSTART
	    call Sccb_OVWRITE.three_write(0x01, 0x18); // HSTOP
	    call Sccb_OVWRITE.three_write(0x02, 0x19); // VSTART
	    call Sccb_OVWRITE.three_write(0xfA, 0x1A); // VSTOP
	    call Sccb_OVWRITE.three_write(0xB6, 0x32); // HREF
	  } else {
	    call Sccb_OVWRITE.three_write(0x16, 0x17); // HSTART
	    call Sccb_OVWRITE.three_write(0x04, 0x18); // HSTOP
	    call Sccb_OVWRITE.three_write(0x02, 0x19); // VSTART
	    call Sccb_OVWRITE.three_write(0x7A, 0x1A); // VSTOP
	    call Sccb_OVWRITE.three_write(0x80, 0x32); // HREF
	  }
	  //TOSH_uwait(100000);
	}
	
	async command ov_stat_t *HplOV7670.get_config()
	{
		return &global_stat;
	}
}
