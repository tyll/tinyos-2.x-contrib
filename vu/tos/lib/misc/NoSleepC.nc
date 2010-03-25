configuration NoSleepC {
}
implementation {
  components McuSleepC, NoSleepP;
  McuSleepC.McuPowerOverride -> NoSleepP;
}