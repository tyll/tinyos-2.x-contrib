#include "OV7649.h"
/**
 * HplOV7649 is the Hpl inteface to the OV7649 series 
 * camera chip.
 *
 */
interface HplOV7649Advanced {
	command uint8_t max_reg_addr();
	command uint8_t get_reg_val(uint8_t addr);
	command uint8_t set_reg_val(uint8_t addr, uint8_t reg_val);
	command ov_stat_t get_ov_stat();
}
