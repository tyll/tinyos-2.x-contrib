/**
 * HplOV7649 is the Hpl inteface to the OV7649 series 
 * camera chip.
 *
 */
#include "OV7649.h"

interface HplOV7649 {
	command error_t init(uint8_t color);
	command void hardware_init();
	command void hard_reset();
	command void soft_reset();
	command void config_rgb();
	command void config_yuv();
	command error_t set_config(ov_config_t *config);
	async command ov_stat_t *get_config();
	command void config_window(uint8_t hstrt, uint8_t hstop, uint8_t vstrt, uint8_t vstop);
}
