/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#ifndef __AT32UC3B_CONFIG_H__
#define __AT32UC3B_CONFIG_H__

#include "at32uc3b.h"

#define AVR32_INTC_INT0             0
#define AVR32_INTC_INT1             1
#define AVR32_INTC_INT2             2
#define AVR32_INTC_INT3             3

/* interrupt priority table (INT[0-3], INT0 means highest priority) */
#define AVR32_INTC_INTLEVEL_DEFAULT  AVR32_INTC_INT3
#define AVR32_INTC_INTLEVEL_GPIO     AVR32_INTC_INT3
#define AVR32_INTC_INTLEVEL_PDCA     AVR32_INTC_INT2
#define AVR32_INTC_INTLEVEL_USART0   AVR32_INTC_INT2
#define AVR32_INTC_INTLEVEL_USART1   AVR32_INTC_INT2
#define AVR32_INTC_INTLEVEL_USART2   AVR32_INTC_INT2

#endif /*__AT32UC3B_CONFIG_H__*/
