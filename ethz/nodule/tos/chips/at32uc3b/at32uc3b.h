/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#ifndef __AT32UC3B_H__
#define __AT32UC3B_H__

#include <stdint.h>
#include <avr32/io.h>

#define PORTA_OFFSET  0x00000000
#define PORTB_OFFSET  0x00000100

#define AVR32_GPIO_PORTA_BASEADDRESS  (AVR32_GPIO_ADDRESS + PORTA_OFFSET)
#define AVR32_GPIO_PORTB_BASEADDRESS  (AVR32_GPIO_ADDRESS + PORTB_OFFSET)
#define get_baseport(gpio)            ((gpio < 32) ? AVR32_GPIO_PORTA_BASEADDRESS : AVR32_GPIO_PORTB_BASEADDRESS)

#define AVR32_GPIO_LOCALBUS_ADDRESS            0x40000000
#define AVR32_GPIO_LOCALBUS_PORTA_BASEADDRESS  (AVR32_GPIO_LOCALBUS_ADDRESS + PORTA_OFFSET)
#define AVR32_GPIO_LOCALBUS_PORTB_BASEADDRESS  (AVR32_GPIO_LOCALBUS_ADDRESS + PORTB_OFFSET)
#define get_baseport_local(gpio)               ((gpio < 32) ? AVR32_GPIO_LOCALBUS_PORTA_BASEADDRESS : AVR32_GPIO_LOCALBUS_PORTB_BASEADDRESS)

#define get_bit(gpio)       (gpio % 32)

#define AVR32_INTC_INTLEVEL_OFFSET  30
#define AVR32_INTC_INT0             0
#define AVR32_INTC_INT1             1
#define AVR32_INTC_INT2             2
#define AVR32_INTC_INT3             3

/* interrupt level table */
#define AVR32_INTC_INTLEVEL_DEFAULT AVR32_INTC_INT3
#define AVR32_INTC_INTLEVEL_GPIO    AVR32_INTC_INT3

#define AVR32_INTC_INTGROUP_GPIO    2

/* clear/set exception/interrupt mask */
#define avr32_clr_global_interrupt_mask()  asm volatile ("csrf %0" : : "i" (AVR32_SR_GM_OFFSET))
#define avr32_set_global_interrupt_mask()  asm volatile ("ssrf %0" : : "i" (AVR32_SR_GM_OFFSET))
#define avr32_clr_interrupt0_mask()        asm volatile ("csrf %0" : : "i" (AVR32_SR_I0M_OFFSET))
#define avr32_set_interrupt0_mask()        asm volatile ("ssrf %0" : : "i" (AVR32_SR_I0M_OFFSET))
#define avr32_clr_interrupt1_mask()        asm volatile ("csrf %0" : : "i" (AVR32_SR_I1M_OFFSET))
#define avr32_set_interrupt1_mask()        asm volatile ("ssrf %0" : : "i" (AVR32_SR_I1M_OFFSET))
#define avr32_clr_interrupt2_mask()        asm volatile ("csrf %0" : : "i" (AVR32_SR_I2M_OFFSET))
#define avr32_set_interrupt2_mask()        asm volatile ("ssrf %0" : : "i" (AVR32_SR_I2M_OFFSET))
#define avr32_clr_interrupt3_mask()        asm volatile ("csrf %0" : : "i" (AVR32_SR_I3M_OFFSET))
#define avr32_set_interrupt3_mask()        asm volatile ("ssrf %0" : : "i" (AVR32_SR_I3M_OFFSET))
#define avr32_clr_exception_mask()         asm volatile ("csrf %0" : : "i" (AVR32_SR_EM_OFFSET))
#define avr32_set_exception_mask()         asm volatile ("ssrf %0" : : "i" (AVR32_SR_EM_OFFSET))
#define avr32_clr_debug_mask()             asm volatile ("csrf %0" : : "i" (AVR32_SR_DM_OFFSET))
#define avr32_set_debug_mask()             asm volatile ("ssrf %0" : : "i" (AVR32_SR_DM_OFFSET))
 
#define get_register(address)  (*((volatile uint32_t *) (address)))

typedef enum gpio_interrupt_mode_enum {
  AVR32_GPIO_INTERRUPT_MODE_CHANGING_EDGE = 0x00,
  AVR32_GPIO_INTERRUPT_MODE_RISING_EDGE = 0x01,
  AVR32_GPIO_INTERRUPT_MODE_FALLING_EDGE = 0x10,
  AVR32_GPIO_INTERRUPT_MODE_RESERVED = 0x11,
  AVR32_GPIO_INTERRUPT_MODE_DISABLED = 0xff
} gpio_interrupt_mode_enum_t;

typedef enum gpio_peripheral_func_enum {
  AVR32_GPIO_PERIPHERAL_FUNC_A = 0x00,
  AVR32_GPIO_PERIPHERAL_FUNC_B = 0x01,
  AVR32_GPIO_PERIPHERAL_FUNC_C = 0x10,
  AVR32_GPIO_PERIPHERAL_FUNC_D = 0x11,
  AVR32_GPIO_PERIPHERAL_FUNC_DISABLED = 0xff
} gpio_peripheral_func_enum_t;

// interesting AVR32 instruction sets
// CBR: clear bit in register
// SBR: set bit in register
// CLZ: count leading zeros
// BREV: bit reverse

// some ideas about AVR32 instruction sets
// SBR: optimize (1 << bit)
// CLZ: seek spare one bits in register 

#endif /*__AT32UC3B_H__*/
