/**
 * A component that is going to use the RF230 Spi bus should
 * create a new component of this to get access to the bus.
 *
 * @author Henrik Makitaavola
 */

#include "Mulle_RF230Spi.h"

generic configuration SoftSpiRF230C()
{
  provides interface Resource;
  provides interface SpiPacket;
  provides interface SpiByte;
  provides interface SoftSpiBus; // <-Should not be used outside the RF230 code!
  //provides interface FastByte;
}
implementation
{
  enum
  {
    CLIENT_ID = unique(UQ_MULLE_SOFTSPIRF230),
  };
  
  components SoftSpiRF230P as Spi;
  SoftSpiBus = Spi.SoftSpiBus;
  Resource = Spi.Resource[CLIENT_ID];
  SpiPacket = Spi.SpiPacket[CLIENT_ID]; 
  SpiByte = Spi.SpiByte[CLIENT_ID]; 
  //FastSpiByte = Spi.FastSpiByte;
}
