/* $Id$ */

/* author: Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#ifndef HARDWARE_H
#define HARDWARE_H

#include "at32uc3b.h"

/* No operation */
inline void nop()
{
  asm volatile ("nop");
}

/* Enables interrupts. */
inline void __nesc_enable_interrupt()
{
  avr32_clr_global_interrupt_mask();
}

/* Disables interrupts. */
inline void __nesc_disable_interrupt()
{
  avr32_set_global_interrupt_mask();
}

typedef uint8_t __nesc_atomic_t;

inline __nesc_atomic_t __nesc_atomic_start(void) @spontaneous()
{
  return 0;
}

inline void __nesc_atomic_end(__nesc_atomic_t x) @spontaneous()
{
}

#endif
