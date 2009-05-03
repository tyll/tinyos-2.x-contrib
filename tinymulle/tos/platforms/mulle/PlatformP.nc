/**
 * Mulle platform initialization code.
 *
 * @author Henrik Makitaavola
 */

#include "hardware.h"
#include "rv8564.h"

module PlatformP
{
  provides interface Init;
  uses interface Init as SubInit;
  uses interface RV8564 as RTC;
  uses interface M16c62pClockCtrl;
  uses interface GeneralIO as PortAVCC;
}

implementation
{
  command error_t Init.init()
  {
    // Init the M16c/62p to run at 10MHz with the sub-clock off.
    call M16c62pClockCtrl.init(MCU_SPEED_10MHz, false);

    // Sub components initialization.
    call SubInit.init();

    // Activate the RTC and set it to output 1024 tics on the CLKOUT pin.
    call RTC.on();
    call RTC.writeRegister(RV8564_CLKF, 0x81);
    call PortAVCC.makeOutput(); // supply power for sensors on MulleZ
    call PortAVCC.set();

    return SUCCESS;
  }

  async event void RTC.fired() {}
}
