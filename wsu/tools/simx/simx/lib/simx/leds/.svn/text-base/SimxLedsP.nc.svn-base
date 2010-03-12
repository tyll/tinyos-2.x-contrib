#ifndef TOSSIM
#error SimX/Sensor is only for use with TOSSIM
#else

#include <stdio.h>
#include <stdarg.h>

#include <sim_tossim.h>
#include "Leds.h"

module SimxLedsP {
  provides interface Leds;
  uses interface SimxPushback as Pushback;
}
implementation {
  uint8_t state = 0;

  static void set(uint8_t val);
  static void on(uint8_t mask);
  static void off(uint8_t mask);
  static void toggle(uint8_t mask);

  async command void Leds.led0On()     {    on(LEDS_LED0);}
  async command void Leds.led0Off()    {   off(LEDS_LED0);}
  async command void Leds.led0Toggle() {toggle(LEDS_LED0);}

  async command void Leds.led1On()     {    on(LEDS_LED1);}
  async command void Leds.led1Off()    {   off(LEDS_LED1);}
  async command void Leds.led1Toggle() {toggle(LEDS_LED1);}

  async command void Leds.led2On()     {    on(LEDS_LED2);}
  async command void Leds.led2Off()    {   off(LEDS_LED2);}
  async command void Leds.led2Toggle() {toggle(LEDS_LED2);}

  async command uint8_t Leds.get() {
    return state;
  }

  async command void Leds.set(uint8_t val) {
    set(val);
  }

  /*
   * Magic that makes all the stuff above work.
   */

  const char *LEDS_SET = "leds.set(lb)b";

  static int32_t pushback(const char *name, ...) {
    va_list va;
    int result;
    long long_result;
    va_start(va, name);
    //Pushback.pushVa(const char *name, pushback_result_t *result,va_list va);
    
    //result = call Pushback.push_va(name, va);
    result = call Pushback.pushLongVa(name, &long_result,va);
    va_end(va);
    return result;
  }

  static void set(uint8_t val) {
    state = val;
    pushback(LEDS_SET, sim_node(), val);
  }

  static void on(uint8_t mask) {
    set(state | mask);
  }

  static void off(uint8_t mask) {
    set(state & (0xFF ^ mask));
  }

  static void toggle(uint8_t mask) {
    set(state ^ mask);
  }

}

#endif /* TOSSIM */
