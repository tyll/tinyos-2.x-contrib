#ifndef _AT91_REGISTER_H
#define _AT91_REGISTER_H

#define _AT91REG(_addr)	(*((volatile uint32_t *)(_addr)))
#define _AT91REG_OFFSET(_addr,_off) (_NXTREG((uint32_t)(_addr) + (uint32_t)(_off)))

#endif /* _NXT_REGISTER_H */
