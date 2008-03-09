/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

module PlatformP
{
  provides interface Init;
  uses interface HplAt32uc3bGeneralIO as RS232_TX;
  uses interface HplAt32uc3bGeneralIO as RS232_RX;
  uses interface HplAt32uc3bGeneralIO as RS232_CTS;
  uses interface HplAt32uc3bGeneralIO as RS232_RTS;
  uses interface Init as LedsInit;
  uses interface Init as InterruptInit;
}
implementation
{
  inline void initClocks() {
    // stop all unused clocks

    get_register(AVR32_PM_ADDRESS + AVR32_PM_CPUMASK) = ((0 << AVR32_CPUMASK_OCD_CLOCK_OFFSET) | 
                                                         (0 << AVR32_CPUMASK_OCD_OFFSET));

    get_register(AVR32_PM_ADDRESS + AVR32_PM_HSBMASK) = ((1 << AVR32_HSBMASK_FLASHC_OFFSET) | 
                                                         (1 << AVR32_HSBMASK_PBA_BRIDGE_OFFSET) | 
                                                         (0 << AVR32_HSBMASK_PBB_BRIDGE_OFFSET) | 
                                                         (0 << AVR32_HSBMASK_USBB_OFFSET) | 
                                                         (0 << AVR32_HSBMASK_PDCA_OFFSET));

    get_register(AVR32_PM_ADDRESS + AVR32_PM_PBAMASK) = ((1 << AVR32_PBAMASK_INTC_OFFSET) | 
                                                         (1 << AVR32_PBAMASK_GPIO_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_PDCA_OFFSET) | 
                                                         (1 << AVR32_PBAMASK_PM_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_ADC_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_SPI_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_TWI_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_USART0_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_USART1_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_USART2_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_PWM_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_SSC_OFFSET) | 
                                                         (0 << AVR32_PBAMASK_TC_OFFSET));

    get_register(AVR32_PM_ADDRESS + AVR32_PM_PBBMASK) = ((0 << AVR32_PBBMASK_HMATRIX_OFFSET) |
                                                         (0 << AVR32_PBBMASK_USBB_OFFSET) |
                                                         (0 << AVR32_PBBMASK_FLASHC_OFFSET));
  }

  inline void initRS232() {
    // bring RS232 lines to a defined level (high)
    call RS232_TX.enablePullup();
    call RS232_RX.enablePullup();
    call RS232_CTS.enablePullup();
    call RS232_RTS.enablePullup();
  }

  command error_t Init.init()
  {
    initClocks();

    initRS232();

    call InterruptInit.init();

    call LedsInit.init();

    return SUCCESS;
  }

  default command error_t InterruptInit.init() { return SUCCESS; }

  default command error_t LedsInit.init() { return SUCCESS; }
}
