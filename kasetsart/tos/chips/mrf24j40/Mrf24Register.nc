/**
 * Define commands for setting and getting MRF24J40 registers
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

interface Mrf24Register
{
  /***
   * Read a short-address register
   *
   * @param reg address of the register whose value to be read
   * @return value of the register
   */
  async command uint8_t readShortAddr(uint8_t reg);

  /***
   * Read a long-address register
   *
   * @param reg address of the register whose value to be read
   * @return value of the register
   */
  async command uint8_t readLongAddr(uint16_t reg);

  /***
   * Write a short-address register
   *
   * @param reg address of the register to be written to
   * @param val new register value
   */
  async command void writeShortAddr(uint8_t reg, uint8_t val);

  /***
   * Write a long-address register
   *
   * @param reg address of the register to be written to
   * @param val new register value
   */
  async command void writeLongAddr(uint16_t reg, uint8_t val);
}
