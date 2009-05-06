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
interface HplOV7670Advanced {
	command uint8_t get_reg_val(uint8_t addr);
	command uint8_t set_reg_val(uint8_t addr, uint8_t reg_val);
	command ov_stat_t get_ov_stat();
}
