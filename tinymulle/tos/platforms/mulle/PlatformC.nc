/**
 * All the wiring of the Mulle platform components.
 *
 * @author Henrik Makitaavola
 */

#include "hardware.h"
#
configuration PlatformC
{
  provides interface Init;
  provides interface RV8564 as RTC;
  provides interface HplDS2745 as BM;
  provides interface Resource;
  uses {
    interface Init as SubInit;
  }
}
implementation
{
  components
    PlatformP,
    M16c62pClockCtrlC,
    RV8564C,
    SoftI2CBusP,
    HplM16c62pGeneralIOC as IOs,
    HplM16c62pInterruptC as Irqs,
    new M16c62pInterruptC() as Irq,
    new SoftI2CMasterC() as I2CMaster,
    new HplDS2745LogicP(0x68) as BMP;

  Init = PlatformP;
  SubInit = PlatformP.SubInit;
  PlatformP.M16c62pClockCtrl -> M16c62pClockCtrlC;
  PlatformP.RTC -> RV8564C;

  // Init the software I2C bus
  SoftI2CBusP.I2CClk -> IOs.PortP71;
  SoftI2CBusP.I2CData -> IOs.PortP70;
  SoftI2CBusP.I2CCtrl -> IOs.PortP75;

  // Initialize the RTC that is connected to pin7 on PortP4 and uses Int0 (pin 2 on PortP8) for interrupts.
  // TODO(Henrik) The RTC shouldnt be wired here, but instead from some code in chips/rv8564 folder.
  RTC = RV8564C;
  RV8564C.GpioInterrupt -> Irq;
  RV8564C -> IOs.PortP47;
  Irq.HplM16c62pInterrupt -> Irqs.Int0;

  //battery monitor
  Resource = I2CMaster.Resource;
  BM=BMP;
  BMP.I2CPacket ->I2CMaster.I2CPacket;
  PlatformP.PortAVCC -> IOs.PortP76;
  
}

