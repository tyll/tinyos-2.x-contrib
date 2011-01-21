/**
 * Implement low-level register access for MRF24J40 chip
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module Mrf24RegisterC
{
  provides interface Mrf24Register as Register;
  uses interface SpiByte;
  uses interface Mrf24SpiCtrl as SpiCtrl;
}
implementation
{
  async command uint8_t Register.readShortAddr(uint8_t reg)
  {
	// TODO Investigate if this code should be in atomic block
    uint8_t val;
    call SpiCtrl.beginPacket();
    call SpiByte.write(reg << 1);
    val = call SpiByte.write(0);
    call SpiCtrl.endPacket();
    return val;
  }

  async command uint8_t Register.readLongAddr(uint16_t reg)
  {
    uint8_t val;
    call SpiCtrl.beginPacket();
    call SpiByte.write( ((reg >> 3) & 0x7F) | 0x80 );
    call SpiByte.write( (reg << 5) & 0xE0 );
    val = call SpiByte.write(0);
    call SpiCtrl.endPacket();
    return val;
  }

  async command void Register.writeShortAddr(uint8_t reg, uint8_t val)
  {
    call SpiCtrl.beginPacket();
    call SpiByte.write( (reg << 1) | 0x01 );
    call SpiByte.write(val);
    call SpiCtrl.endPacket();
  }

  async command void Register.writeLongAddr(uint16_t reg, uint8_t val)
  {
    call SpiCtrl.beginPacket();
    call SpiByte.write( ((reg >> 3) & 0x7F) | 0x80 );
    call SpiByte.write( ((reg << 5) & 0xE0) | 0x10 );
    call SpiByte.write(val);
    call SpiCtrl.endPacket();
  }
}
