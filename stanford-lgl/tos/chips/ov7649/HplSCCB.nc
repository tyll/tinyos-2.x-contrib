/**
 * HplOV7649SCCB is the Hpl inteface to serial camera control bus 
 * (SCCB) of the OV7649 camera chip.
 *
 */

interface HplSCCB {
  command error_t init();
  command error_t three_write(uint8_t data_out, uint8_t address);
  command error_t two_write(uint8_t address);
  command error_t read(uint8_t *data_in);
}
