/**
 * Creates a new Software Spi bus that will be used by the RF230
 * chip.
 *
 * @author Henrik Makitaavola
 */

configuration SoftSpiRF230P
{
  provides interface Resource[uint8_t client];
  provides interface SpiPacket[uint8_t client];
  provides interface SpiByte[uint8_t client];
  provides interface SoftSpiBus;
 // provides interface FastSpiByte;

}
implementation
{
  components new SoftSpiMasterP(UQ_MULLE_SOFTSPIRF230) as Spi,
      new SoftSpiBusP(),
      HplM16c62pGeneralIOC as IOs;
  
  // Init the software SPI bus
  SoftSpiBusP.SCLK -> IOs.PortP33;
  SoftSpiBusP.MISO -> IOs.PortP10;
  SoftSpiBusP.MOSI -> IOs.PortP11;

  Spi.SoftSpiBus -> SoftSpiBusP;
  SoftSpiBus = SoftSpiBusP;

  Resource  = Spi.Resource;
  SpiPacket = Spi.SpiPacket;
  SpiByte = Spi.SpiByte;
/**

  async command void FastSpiByte.splitWrite(uint8_t data)
  {

    call SpiByte.write(data);
  }

  async command uint8_t FastSpiByte.write(uint8_t data)
  {
    return 0;
  }

  async command uint8_t FastSpiByte.splitRead()
  {
    return 0;
  }

  async command uint8_t FastSpiByte.splitReadWrite(uint8_t data)
  { 
    //call SpiByte.write(data);
    return data;
  }
*/

}
