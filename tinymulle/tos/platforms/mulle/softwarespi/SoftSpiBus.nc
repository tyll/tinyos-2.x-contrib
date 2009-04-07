/**
 * Interface for a software Spi bus.
 *
 * @author Henrik Makitaavola
 */
interface SoftSpiBus
{
  /**
   * Initializes bus default state.
   */
  async command void init();
  
  /**
   * Turn the bus off.
   */
  async command void off();

  /**
   * Reads a byte from the Spi bus.
   *
   * @return A byte from the bus.
   */
  async command uint8_t readByte();

  /**
   * Writes a byte on th Spi bus.
   *
   * @param byte the byte to write.
   */
  async command void writeByte(uint8_t byte);
  
  /**
   * Read and write a byte to the bus at the same time.
   *
   * @param byte The byte to write.
   * @return Byte read from the bus.
   */
  async command uint8_t write(uint8_t byte);
}
