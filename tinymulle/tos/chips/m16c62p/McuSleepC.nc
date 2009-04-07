/**
 * Wiring of TEP 112 (Microcontroller Power Management).
 *
 * @author Henrik Makitaavola
 */
// TODO(henrik) Add the stop mode for the lowest power saving state.
configuration McuSleepC
{
  provides interface McuSleep;
  provides interface McuPowerState;

  uses interface McuPowerOverride;
}
implementation
{
  components McuSleepP,
      M16c62pClockCtrlC;

  McuSleep = McuSleepP;
  McuPowerState = McuSleepP;
  McuSleepP = McuPowerOverride;
  McuSleepP.M16c62pClockCtrl -> M16c62pClockCtrlC;
}
