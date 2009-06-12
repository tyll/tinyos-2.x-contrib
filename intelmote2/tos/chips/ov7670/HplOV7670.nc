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

interface HplOV7670 {
	command error_t init(uint8_t color, uint8_t type, uint8_t size);
	command void hardware_init();
	command void hard_reset();
	command void soft_reset();
	command void config_rgb(uint8_t size);
	command void config_yuv(uint8_t size);
	// command error_t set_config(ov_config_t *config);
	async command ov_stat_t *get_config();
	command void config_window(uint8_t size);
}
