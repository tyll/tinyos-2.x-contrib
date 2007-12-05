/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

module McuSleepC
{
  provides
  {
    interface McuSleep;
    interface McuPowerState;
  }
}
implementation
{
  async command void McuSleep.sleep()
  {
    __nesc_enable_interrupt();
    __nesc_disable_interrupt();
  }

  async command void McuPowerState.update()
  {
  }
}
