#include "Atm328Adc.h"

/**
 * HPL for the Atmega328 A/D conversion susbsystem.
 *
 * @notes
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/adc/HplAtm128AdcC.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

configuration HplAtm328AdcC 
{
  provides interface HplAtm328Adc;
}
implementation {
  components HplAtm328AdcP, McuSleepC;

  HplAtm328Adc = HplAtm328AdcP;
  HplAtm328AdcP.McuPowerState -> McuSleepC;
}

