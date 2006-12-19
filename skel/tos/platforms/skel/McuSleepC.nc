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
  }

  async command void McuPowerState.update() {
  }
}
