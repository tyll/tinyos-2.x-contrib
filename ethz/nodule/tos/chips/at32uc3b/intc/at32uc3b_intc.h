/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#ifndef __AT32UC3B_INTC_H__
#define __AT32UC3B_INTC_H__

#include "at32uc3b.h"

#define AVR32_INTC_INTLEVEL_OFFSET  30

#define get_avr32_intc_intlevel_usart(usart) \
        ((usart == 0) ? AVR32_INTC_INTLEVEL_USART0 : ((usart == 1) ? AVR32_INTC_INTLEVEL_USART1 : \
        ((usart == 2) ? AVR32_INTC_INTLEVEL_USART2 : AVR32_INTC_INTLEVEL_USART0 )))

#define AVR32_INTC_INTGROUP_PM               1
#define AVR32_INTC_INTGROUP_GPIO             2
#define AVR32_INTC_INTGROUP_GPIO_REQ_OFFSET  AVR32_GPIO_IFR0
#define AVR32_INTC_INTGROUP_PDCA             3
#define AVR32_INTC_INTGROUP_PDCA_REQ_OFFSET  AVR32_INTC_IRR3
#define AVR32_INTC_INTGROUP_USART0           5
#define AVR32_INTC_INTGROUP_USART1           6
#define AVR32_INTC_INTGROUP_USART2           7

#define get_avr32_intc_intgroup_usart(usart) \
        ((usart == 0) ? AVR32_INTC_INTGROUP_USART0 : ((usart == 1) ? AVR32_INTC_INTGROUP_USART1 : \
        ((usart == 2) ? AVR32_INTC_INTGROUP_USART2 : AVR32_INTC_INTGROUP_USART0 )))

#endif /*__AT32UC3B_INTC_H__*/
