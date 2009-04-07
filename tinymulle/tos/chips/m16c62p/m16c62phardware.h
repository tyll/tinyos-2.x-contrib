/**
 * Some M16c/62p needed macros and defines.
 *
 * @author Henrik Makitaavola
 */

#ifndef __M16C62PHARDWARE_H__
#define __M16C62PHARDWARE_H__

#include "interrupts.h"
#include "iom16c62p.h"
#include "bits.h"

#define true 1
#define false 0

// We need slightly different defs than M16C_INTERRUPT
// for interrupt handlers.
#define M16C_INTERRUPT_HANDLER(id) \
  M16C_INTERRUPT(id) @atomic_hwevent() @C()

//Bit operators using bit number
#define _BV(bit)  (1 << bit)
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

typedef uint8_t mcu_power_t @combine("ecombine");
// added at 2009-01-27 Fan Zhang
mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2) @safe() {
  return (m1 < m2) ? m1: m2;
}
enum {
  M16C62P_POWER_IDLE        = 0,	// no use
  M16C62P_POWER_ADC_NR      = 1,	// no use
  M16C62P_POWER_EXT_STANDBY = 2,	// no use
  M16C62P_POWER_SAVE        = 3,	// no use
  M16C62P_POWER_WAIT        = 4,
  M16C62P_POWER_STOP        = 5, 
};
// added at 2009-01-27 Fan Zhang
inline void __nesc_enable_interrupt(void) @safe() { asm("fset i"); }
inline void __nesc_disable_interrupt(void) @safe() { asm("fclr i"); }

typedef uint16_t __nesc_atomic_t;

/**
 * Start atomic section.
 */
inline __nesc_atomic_t __nesc_atomic_start(void) @spontaneous() @safe()
{
  __nesc_atomic_t result;
  // Disable interrupts
  __nesc_disable_interrupt();
  // Save the flag register (FLG)
  asm volatile ("stc flg, %0": "=r"(result): : "%flg");
  asm volatile("" : : : "memory"); // ensure atomic section effect visibility
  return result;
}

/**
 * End atomic section.
 */
inline void __nesc_atomic_end(__nesc_atomic_t original_FLG) @spontaneous() @safe()
{
  // Restore the flag register (FLG)
  asm volatile("" : : : "memory"); // ensure atomic section effect visibility
  asm volatile ("ldc %0, flg": : "r"(original_FLG): "%flg");
}

// If the platform doesnt have defined any main crystal speed it will
// get a default value of 16MHz
#ifndef MAIN_CRYSTAL_SPEED
#define MAIN_CRYSTAL_SPEED 16 /*MHZ*/
#endif

/**
 * Input to M16c62pInit.init().
 * The cpu speed is derived from 'MAIN_CRYSTAL_SPEED'/M16c62pMainClkDiv.
 */
typedef enum
{
  M16C62P_MAIN_CLK_DIV_0 = 0x0,
  M16C62P_MAIN_CLK_DIV_2 = 0x1,
  M16C62P_MAIN_CLK_DIV_4 = 0x2,
  M16C62P_MAIN_CLK_DIV_8 = 0x4,
  M16C62P_MAIN_CLK_DIV_16 = 0x3
} M16c62pMainClkDiv;

#endif  // __M16C62PHARDWARE_H__
