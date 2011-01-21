/** 
 * This file defines various macros and functions for ATmega328 low-level
 * hardware control such as interrupts and power management.
 *
 * @notes
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/atm128hardware.h</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

#ifndef _H_atmega328hardware_H
#define _H_atmega328hardware_H

#include <avr/io.h>
#if __AVR_LIBC_VERSION__ >= 10400UL
#include <avr/interrupt.h>
#else
#include <avr/interrupt.h>
#include <avr/signal.h>
#endif
#include <avr/wdt.h>
#include <avr/pgmspace.h>
#include "atm328const.h"

/* We need slightly different defs than SIGNAL, INTERRUPT */
#define AVR_ATOMIC_HANDLER(signame) \
  ISR(signame) @atomic_hwevent() @C()

#define AVR_NONATOMIC_HANDLER(signame) \
  void signame(void) __attribute__ ((interrupt)) @hwevent() @C()

/* Macro to create union casting functions. */
#define DEFINE_UNION_CAST(func_name, from_type, to_type) \
  to_type func_name(from_type x) { \
  union {from_type f; to_type t;} c = {f:x}; return c.t; }

// Bit operators using bit number
#define SET_BIT(port, bit)    ((port) |= _BV(bit))
#define CLR_BIT(port, bit)    ((port) &= ~_BV(bit))
#define READ_BIT(port, bit)   (((port) & _BV(bit)) != 0)
#define FLIP_BIT(port, bit)   ((port) ^= _BV(bit))
#define WRITE_BIT(port, bit, value) \
   if (value) SET_BIT((port), (bit)); \
   else CLR_BIT((port), (bit))

// Bit operators using bit flag mask
#define SET_FLAG(port, flag)  ((port) |= (flag))
#define CLR_FLAG(port, flag)  ((port) &= ~(flag))
#define READ_FLAG(port, flag) ((port) & (flag))

/* Enables interrupts. */
inline void __nesc_enable_interrupt() @safe() {
    sei();
}
/* Disables all interrupts. */
inline void __nesc_disable_interrupt() @safe() {
    cli();
}

/* Defines data type for storing interrupt mask state during atomic. */
typedef uint8_t __nesc_atomic_t;
__nesc_atomic_t __nesc_atomic_start(void);
void __nesc_atomic_end(__nesc_atomic_t original_SREG);

#ifndef NESC_BUILD_BINARY
/* @spontaneous() functions should not be included when NESC_BUILD_BINARY
   is #defined, to avoid duplicate functions definitions wheb binary
   components are used. Such functions do need a prototype in all cases,
   though. */

/* Saves current interrupt mask state and disables interrupts. */
inline __nesc_atomic_t 
__nesc_atomic_start(void) @spontaneous() @safe()
{
    __nesc_atomic_t result = SREG;
    __nesc_disable_interrupt();
    asm volatile("" : : : "memory"); /* ensure atomic section effect visibility */
    return result;
}

/* Restores interrupt mask to original state. */
inline void 
__nesc_atomic_end(__nesc_atomic_t original_SREG) @spontaneous() @safe()
{
  asm volatile("" : : : "memory"); /* ensure atomic section effect visibility */
  SREG = original_SREG;
}
#endif

/* Defines the mcu_power_t type for atm328 power management. */
typedef uint8_t mcu_power_t @combine("mcombine");


enum {
  ATM328_POWER_IDLE        = 0,
  ATM328_POWER_ADC_NR      = 1,
  ATM328_POWER_EXT_STANDBY = 2,
  ATM328_POWER_SAVE        = 3,
  ATM328_POWER_STANDBY     = 4,
  ATM328_POWER_DOWN        = 5, 
};

/* Combine function.  */
mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2) @safe() {
  return (m1 < m2)? m1: m2;
}

#endif //_H_atmega328hardware_H


