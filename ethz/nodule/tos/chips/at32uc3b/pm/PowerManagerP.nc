/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b_pm.h"

module PowerManagerP
{
  provides interface PowerManager;
}
implementation
{
  command void PowerManager.enable32KHzOscillator() {
    get_register(AVR32_PM_ADDRESS + AVR32_PM_OSCCTRL32) = ((1 << AVR32_PM_OSCCTRL32_OSC32EN_OFFSET) | 
                                                           (AVR32_PM_OSCCTRL32_MODE_CRYSTAL << AVR32_PM_OSCCTRL32_MODE_OFFSET) | 
                                                           (AVR32_PM_OSCCTRL32_DEFAULT_STARTUP << AVR32_PM_OSCCTRL32_STARTUP_OFFSET)); 
  }
}
