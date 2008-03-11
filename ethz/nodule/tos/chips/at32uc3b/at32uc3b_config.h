/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#ifndef __AT32UC3B_CONFIG_H__
#define __AT32UC3B_CONFIG_H__

#include "at32uc3b.h"

/* interrupt priority table (0-3, 0 means highest priority) */
#define AVR32_INTC_INTLEVEL_DEFAULT   3
#define AVR32_INTC_INTLEVEL_PM        1
#define AVR32_INTC_INTLEVEL_GPIO      3
#define AVR32_INTC_INTLEVEL_PDCA      2
#define AVR32_INTC_INTLEVEL_USART0    2
#define AVR32_INTC_INTLEVEL_USART1    2
#define AVR32_INTC_INTLEVEL_USART2    2

/* startup time of 32 KHz oscillator */
/* STARTUP    clock cycles
 * 0          0
 * 1          128
 * 2          8192
 * 3          16384
 * 4          65536
 * 5          131072
 * 6          262144
 * 7          524288
 */
#define AVR32_PM_OSCCTRL32_DEFAULT_STARTUP    5

#endif /*__AT32UC3B_CONFIG_H__*/
