/**
 * Define an interface for controlling logic on Slave Select (SS) pin, as
 * MRF24J40 requires pulling this pin down and up to indicate the start and
 * end of a SPI packet, respectively.
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
interface Mrf24SpiCtrl
{
  /***
   * Select the chip and indicate the start of SPI packet
   */
  async command void beginPacket();

  /***
   * Deselect the chip and indicate the end of SPI packet
   */
  async command void endPacket();
}
