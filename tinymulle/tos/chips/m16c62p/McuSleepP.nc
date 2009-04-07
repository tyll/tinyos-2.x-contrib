/**
 * Implementation of TEP 112 (Microcontroller Power Management).
 *
 * @author Henrik Makitaavola
 */
// TODO(henrik) Add the stop mode for the lowest power saving state.
module McuSleepP
{
  provides interface McuSleep;
  provides interface McuPowerState;

  uses interface McuPowerOverride;
  uses interface M16c62pClockCtrl;
}
implementation
{
#ifdef ENABLE_STOP_MODE
  bool stop_mode = true;
#else
  bool stop_mode = false;
#endif

  void updatePowerState()
  {
#ifdef ENABLE_STOP_MODE
    atomic
    { 
	  // TODO(Henrik) More needs to be taken into account if stop mode should
	  //              be entered when more components get implemnted.
      if (READ_BIT(TB5IC.BYTE, 0) || // TimerB5 is not runned by the RTC (Mulle specific)
          U0C1.BIT.TE || // UART0 (All uarts are indicated on by transmit enable bit)
          U1C1.BIT.TE || // UART1
          U2C1.BIT.TE_U2C1) // UART2
      {
        stop_mode = false;
      }
      else
      {
        stop_mode = true;
      }
    }
#endif
  }
  
  async command void McuSleep.sleep()
  {
    bool stop_mode_; // Used to store power state before wakeup.

    atomic stop_mode_ = stop_mode;
    PRCR.BIT.PRC0 = 1; // Turn off protection of system clock control registers 0 & 1
    //CM0.BIT.CM0_2 = 1; // Stop Peripheral function clock in wait mode
    if (!stop_mode_)
    {
      __nesc_enable_interrupt();
      asm ("wait");
    }
    else
    {
      __nesc_enable_interrupt();
      CM1.BIT.CM1_0 = 1;
      // The pipeline must be flushed after stop mode for the mcu to work correctly.
      asm("nop");
      asm("nop");
      asm("nop");
      asm("nop");
      asm("nop");
      asm("nop");
    }
    // All of memory may change at this point...
    asm volatile ("" : : : "memory");
    __nesc_disable_interrupt();
    // If stop mode was used the clocks need to be re initialized.
    if (stop_mode_)
    {
      // !!!! This call turns on protection on the system clock registers 0 & 1. !!!!
      call M16c62pClockCtrl.reInit();
    }
    PRCR.BIT.PRC0 = 0; // Turn on protection of system clock control registers 0 & 1
  }

  async command void McuPowerState.update()
  {
    updatePowerState();
  }

  default async command mcu_power_t McuPowerOverride.lowestState()
  {
    return 0;
  }
}
