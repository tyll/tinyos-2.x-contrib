module NoSleepP {
  provides interface McuPowerOverride;
}
implementation {
  async command mcu_power_t McuPowerOverride.lowestState() {
#if defined(PLATFORM_TELOS) ||  defined(PLATFORM_TELOSA) ||  defined(PLATFORM_TELOSB) ||  defined(PLATFORM_EPIC)
    return MSP430_POWER_ACTIVE;
#elif defined(PLATFORM_MICA2) ||  defined(PLATFORM_MICAZ) ||  defined(PLATFORM_XSM) ||  defined(PLATFORM_IRIS) ||  defined(PLATFORM_ZIGBIT)
    return ATM128_POWER_IDLE;
#else
#warning Assuming 0 is the IDLE power state that prevents MCU from sleep
    return 0;
#endif
  }
}