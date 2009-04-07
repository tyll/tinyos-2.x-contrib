/**
 * Interface for a software I2C bus.
 *
 * @author Henrik Makitaavola
 */
interface SoftI2CBus
{
  /*
   * Initializes bus default state.
   */
  async command void init();
  
  /*
   * Turn the bus off.
   */
  async command void off();

  /*
   * Generates a start condition on the bus.
   */
  async command void start();

  /*
   * Generates a stop condition.
   */
  async command void stop();

  /*
   * Restarts a I2C bus transaction.
   */
  async command void restart();

  /*
   * Reads a byte from the I2C bus.
   *
   * @param ack If true ack the read byte else nack.
   * @return A byte from the bus.
   */
  async command uint8_t readByte(bool ack);

  /*
   * Writes a byte on th I2C bus.
   * Send the data( or address) C  and wait for acknowledge after finishing
   * sending it. Nonacknowledge sets ACK=0 and normal sending sets ACK=1.
   *
   * @param byte the byte to write.
   */
  async command void writeByte(uint8_t byte);
  
  /*
   * Master sends the ACK (LowLevel), working as a master-receiver.
   */
  async command void masterAck();

  /*
   * Master sends the NACK (HighLevel), working as a master-receiver.
   */
  async command void masterNack();
}
