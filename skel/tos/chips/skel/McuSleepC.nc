/**
 * Dummy sleep for the skel platform
 *
 * @author Martin Leopold
 */

module McuSleepC {
  provides {
    interface McuSleep;
    interface McuPowerState;
  }
}
implementation {
  
  async command void McuSleep.sleep() {
    // Allow interrupts to squize in... (See TEP112)
    __nesc_enable_interrupt();
    __nesc_disable_interrupt();
  }

  async command void McuPowerState.update() {
  }
}
