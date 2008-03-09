/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#ifndef __AT32UC3B_H__
#define __AT32UC3B_H__

#include <stdint.h>
#include <avr32/io.h>

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

#define get_avr32_pdca_baseaddress(pdca)       (AVR32_PDCA_ADDRESS + (AVR32_PDCA_MAR1 * pdca))

#define get_avr32_usart_baseaddress(usart) \
        ((usart == 0) ? AVR32_USART0_ADDRESS : ((usart == 1) ? AVR32_USART1_ADDRESS : ((usart == 2) ? AVR32_USART2_ADDRESS : AVR32_USART0_ADDRESS )))

#ifndef AVR32_USART0_ALTERNATIVE_GPIO_MAPPING
#define AVR32_GPIO_PERIPHERAL_FUNC_USART0 AVR32_GPIO_PERIPHERAL_FUNC_C
#else
#define AVR32_GPIO_PERIPHERAL_FUNC_USART0 AVR32_GPIO_PERIPHERAL_FUNC_A
#endif

#ifndef AVR32_USART1_ALTERNATIVE_GPIO_MAPPING
#define AVR32_GPIO_PERIPHERAL_FUNC_USART1 AVR32_GPIO_PERIPHERAL_FUNC_A
#else
#define AVR32_GPIO_PERIPHERAL_FUNC_USART1 AVR32_GPIO_PERIPHERAL_FUNC_C
#endif

#ifndef AVR32_USART2_ALTERNATIVE_GPIO_MAPPING
#define AVR32_GPIO_PERIPHERAL_FUNC_USART2 AVR32_GPIO_PERIPHERAL_FUNC_B
#else
#define AVR32_GPIO_PERIPHERAL_FUNC_USART2 AVR32_GPIO_PERIPHERAL_FUNC_C
#endif

#define get_avr32_usart_peripheral_function(usart) \
        ((usart == 0) ? AVR32_GPIO_PERIPHERAL_FUNC_USART0 : ((usart == 1) ? AVR32_GPIO_PERIPHERAL_FUNC_USART1 : \
        ((usart == 2) ? AVR32_GPIO_PERIPHERAL_FUNC_USART2 : AVR32_GPIO_PERIPHERAL_FUNC_USART0 )))

#define AVR32_CPUMASK_OCD_CLOCK_OFFSET   0
#define AVR32_CPUMASK_OCD_OFFSET         1

#define AVR32_HSBMASK_FLASHC_OFFSET      0
#define AVR32_HSBMASK_PBA_BRIDGE_OFFSET  1
#define AVR32_HSBMASK_PBB_BRIDGE_OFFSET  2
#define AVR32_HSBMASK_USBB_OFFSET        3
#define AVR32_HSBMASK_PDCA_OFFSET        4

#define AVR32_PBAMASK_INTC_OFFSET        0
#define AVR32_PBAMASK_GPIO_OFFSET        1
#define AVR32_PBAMASK_PDCA_OFFSET        2
#define AVR32_PBAMASK_PM_OFFSET          3
#define AVR32_PBAMASK_ADC_OFFSET         4
#define AVR32_PBAMASK_SPI_OFFSET         5
#define AVR32_PBAMASK_TWI_OFFSET         6
#define AVR32_PBAMASK_USART0_OFFSET      7
#define AVR32_PBAMASK_USART1_OFFSET      8
#define AVR32_PBAMASK_USART2_OFFSET      9
#define AVR32_PBAMASK_PWM_OFFSET         10
#define AVR32_PBAMASK_SSC_OFFSET         11
#define AVR32_PBAMASK_TC_OFFSET          12

#define get_avr32_usart_pbamask_offset(usart) \
        ((usart == 0) ? AVR32_PBAMASK_USART0_OFFSET : ((usart == 1) ? AVR32_PBAMASK_USART1_OFFSET : \
        ((usart == 2) ? AVR32_PBAMASK_USART2_OFFSET : AVR32_PBAMASK_USART0_OFFSET )))

#define AVR32_PBBMASK_HMATRIX_OFFSET     0
#define AVR32_PBBMASK_USBB_OFFSET        1
#define AVR32_PBBMASK_FLASHC_OFFSET      2

#define AVR32_INTC_INTLEVEL_OFFSET  30
#define AVR32_INTC_INT0             0
#define AVR32_INTC_INT1             1
#define AVR32_INTC_INT2             2
#define AVR32_INTC_INT3             3

/* interrupt level table */
#define AVR32_INTC_INTLEVEL_DEFAULT  AVR32_INTC_INT3
#define AVR32_INTC_INTLEVEL_GPIO     AVR32_INTC_INT3
#define AVR32_INTC_INTLEVEL_PDCA     AVR32_INTC_INT2
#define AVR32_INTC_INTLEVEL_USART0   AVR32_INTC_INT2
#define AVR32_INTC_INTLEVEL_USART1   AVR32_INTC_INT2
#define AVR32_INTC_INTLEVEL_USART2   AVR32_INTC_INT2

#define get_avr32_intc_intlevel_usart(usart) \
        ((usart == 0) ? AVR32_INTC_INTLEVEL_USART0 : ((usart == 1) ? AVR32_INTC_INTLEVEL_USART1 : \
        ((usart == 2) ? AVR32_INTC_INTLEVEL_USART2 : AVR32_INTC_INTLEVEL_USART0 )))

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
