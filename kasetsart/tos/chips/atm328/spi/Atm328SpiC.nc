/**
 * The HAL of the SPI bus on the ATmega328.
 *
 * @notes 
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/spi/Atm128SpiC.nc</code>
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

configuration Atm328SpiC {
  provides interface Init;
  provides interface Atm328Spi;
  provides interface SpiByte;
  provides interface SpiPacket;
  provides interface Resource[uint8_t id];
}
implementation {
  components Atm328SpiP as SpiMaster, HplAtm328SpiC as HplSpi;
  components new SimpleFcfsArbiterC("Atm328SpiC.Resource") as Arbiter;
  components McuSleepC;
  
  Init      = SpiMaster;
  
  SpiByte   = SpiMaster;
  SpiPacket = SpiMaster;
  Resource  = SpiMaster;
  Atm328Spi = HplSpi.SpiBus;

  SpiMaster.ResourceArbiter -> Arbiter;
  SpiMaster.ArbiterInfo     -> Arbiter;
  SpiMaster.Spi             -> HplSpi;
  SpiMaster.McuPowerState   -> McuSleepC;
}
