/**
 * Configuration encapsulating the basic SPI HPL for ATmega328.
 *
 * @notes 
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/spi/HplAtm128SpiC.nc</code>
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

configuration HplAtm328SpiC {
    provides interface Atm328Spi as SpiBus;
}
implementation
{
  components HplAtm328GeneralIOC as IO, HplAtm328SpiP as HplSpi;
  components McuSleepC;
  
  SpiBus = HplSpi;

  HplSpi.Mcu -> McuSleepC;
  HplSpi.SS   -> IO.PortB2;  // Slave set line
  HplSpi.SCK  -> IO.PortB5;  // SPI clock line
  HplSpi.MOSI -> IO.PortB3;  // Master out, slave in
  HplSpi.MISO -> IO.PortB4;  // Master in, slave out
}
