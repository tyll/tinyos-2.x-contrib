/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#ifndef __AT32UC3B_GPIO_H__
#define __AT32UC3B_GPIO_H__

#include "at32uc3b.h"

#define PORTA_OFFSET  0x00000000
#define PORTB_OFFSET  0x00000100

#define AVR32_GPIO_PORTA_BASEADDRESS      (AVR32_GPIO_ADDRESS + PORTA_OFFSET)
#define AVR32_GPIO_PORTB_BASEADDRESS      (AVR32_GPIO_ADDRESS + PORTB_OFFSET)
#define get_avr32_gpio_baseaddress(gpio)  ((gpio < 32) ? AVR32_GPIO_PORTA_BASEADDRESS : AVR32_GPIO_PORTB_BASEADDRESS)

#define AVR32_GPIO_LOCALBUS_ADDRESS             0x40000000
#define AVR32_GPIO_LOCALBUS_PORTA_BASEADDRESS   (AVR32_GPIO_LOCALBUS_ADDRESS + PORTA_OFFSET)
#define AVR32_GPIO_LOCALBUS_PORTB_BASEADDRESS   (AVR32_GPIO_LOCALBUS_ADDRESS + PORTB_OFFSET)
#define get_avr32_gpio_baseaddress_local(gpio)  ((gpio < 32) ? AVR32_GPIO_LOCALBUS_PORTA_BASEADDRESS : AVR32_GPIO_LOCALBUS_PORTB_BASEADDRESS)

#define get_avr32_gpio_bit(gpio)               (gpio % 32)

#endif /*__AT32UC3B_GPIO_H__*/
