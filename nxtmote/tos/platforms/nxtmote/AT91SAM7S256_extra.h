/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */

#ifndef AT91SAM7S256_EXTRA_H
#define AT91SAM7S256_EXTRA_H

#define CPSR_I_BIT			(0x80)
#define CPSR_F_BIT			(0x40)
#define	ARM_CPSR_INT_MASK 	(0x000000C0)

#define GPIO_pin_bit(_pin)  (1 << _pin)

//TODO: Same
#define   AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL       ((unsigned int) 0x0 <<  5) // (AIC) Internal Sources Code Label High-level Sensitive
#define   AT91C_AIC_SRCTYPE_EXT_LOW_LEVEL        ((unsigned int) 0x0 <<  5) // (AIC) External Sources Code Label Low-level Sensitive

#endif
