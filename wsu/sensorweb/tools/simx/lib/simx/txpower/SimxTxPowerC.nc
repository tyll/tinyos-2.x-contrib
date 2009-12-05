#ifndef TOSSIM
#error "Simx/TxPower is only for use with TOSSIM"
#endif

#include <stdio.h>
#include <stdarg.h>

module SimxTxPowerC {
  uses interface Pushback;
  provides interface SimxTxPower as TxPower;
}
implementation {
  const char *TXPOWER_SET = "txpower.set(ll)l";
  const char *TXPOWER_GET = "txpower.get(l)l";

  static uint8_t pushback(const char *name, ...) {
    va_list va;
    int result;
    va_start(va, name);
    result = call Pushback.push_va(name, va);
    va_end(va);
    return result;
  }

  static uint8_t set_power(uint8_t power) {
    return pushback(TXPOWER_SET, (long)sim_node(), (long)power);
  }

  async command uint8_t TxPower.getPower() {
    return pushback(TXPOWER_GET, (long)sim_node());
  }

  async command uint8_t TxPower.setPower(uint8_t power) {
    return pushback(TXPOWER_SET, (long)sim_node(), (long)power);
  }

}
