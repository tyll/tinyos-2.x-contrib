#ifndef _AT91_REGISTER_H
#define _AT91_REGISTER_H

#define _AT91REG(_addr)	(*((volatile uint32_t *)(_addr)))
#define _AT91REG_OFFSET(_addr,_off) (_NXTREG((uint32_t)(_addr) + (uint32_t)(_off)))

/* GPIO */
#define PIOPER  _AT91REG(0xFFFFF400)
#define PIOOER  _AT91REG(0xFFFFF410)
#define PIOSODR _AT91REG(0xFFFFF430)
#define PIOCODR _AT91REG(0xFFFFF434)

/* LEDS */
//#define LED0 0x01
//#define LED1 0x02
//#define LED2 0x04

#endif /* _NXT_REGISTER_H */
