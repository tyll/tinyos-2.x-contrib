#ifndef _OV7649SCCB_H
#define _OV7649SCCB_H

#define OV7649SCCB_SCLK_PIN		0x0010		// PIOE4
#define OV7649SCCB_SDATA_PIN	0x0008		// PIOE3
#define OV7649SCCB_SCCB_MODE	GPPME
#define OV7649SCCB_SCCB_IN		GPPIE
#define OV7649SCCB_SCCB_OUT		GPPOE

#define sdata_out()	{ _GPIO_setaltfn(56,0);GPDR(56) |= _GPIO_bit(56); }/*call SIOD.makeOutput(); }*/
#define sdata_in()	{ _GPIO_setaltfn(56,0);GPDR(56) &= ~(_GPIO_bit(56)); }/*call SIOD.makeInput(); }*/
#define sdata_set() { GPSR(56) |= _GPIO_bit(56); } /*call SIOD.set(); }*/
#define sdata_clr() { GPCR(56) |= _GPIO_bit(56); } /*call SIOD.clr(); }*/
#define sdata_get() { ((GPLR(56) & _GPIO_bit(56)) != 0); } /*call SIOD.get(); }*/

#define sclock_out()	{ _GPIO_setaltfn(57,0);GPDR(57) |= _GPIO_bit(57); }/*call SIOD.makeOutput(); }*/
#define sclock_set() { GPSR(57) |= _GPIO_bit(57); } /*call SIOD.set(); }*/
#define sclock_clr() { GPCR(57) |= _GPIO_bit(57); } /*call SIOD.clr(); }*/

#define pwdn_out()	{ _GPIO_setaltfn(82,0);GPDR(82) |= _GPIO_bit(82); }/*call SIOD.makeOutput(); }*/
#define pwdn_in()	{ _GPIO_setaltfn(82,0);GPDR(82) &= ~(_GPIO_bit(82)); }/*call SIOD.makeInput(); }*/
#define pwdn_set() { GPSR(82) |= _GPIO_bit(82); } /*call SIOD.set(); }*/
#define pwdn_clr() { GPCR(82) |= _GPIO_bit(82); } /*call SIOD.clr(); }*/
#define pwdn_get() { ((GPLR(82) & _GPIO_bit(82)) != 0); } /*call SIOD.get(); }*/

#define reset_out()	{ _GPIO_setaltfn(83,0);GPDR(83) |= _GPIO_bit(83); }/*call SIOD.makeOutput(); }*/
#define reset_in()	{ _GPIO_setaltfn(83,0);GPDR(83) &= ~(_GPIO_bit(83)); }/*call SIOD.makeInput(); }*/
#define reset_set() { GPSR(83) |= _GPIO_bit(83); } /*call SIOD.set(); }*/
#define reset_clr() { GPCR(83) |= _GPIO_bit(83); } /*call SIOD.clr(); }*/
#define reset_get() { ((GPLR(83) & _GPIO_bit(83)) != 0); } /*call SIOD.get(); }*/

#define led_out()	{ _GPIO_setaltfn(106,0);GPDR(106) |= _GPIO_bit(106); }/*call SIOD.makeOutput(); }*/
#define led_in()	{ _GPIO_setaltfn(106,0);GPDR(106) &= ~(_GPIO_bit(106)); }/*call SIOD.makeInput(); }*/
#define led_set() { GPSR(106) |= _GPIO_bit(106); } /*call SIOD.set(); }*/
#define led_clr() { GPCR(106) |= _GPIO_bit(106); } /*call SIOD.clr(); }*/
#define led_get() { ((GPLR(106) & _GPIO_bit(106)) != 0); } /*call SIOD.get(); }*/

//#define sccb_delay() {  uint8_t i=20;  while (--i != 0) asm volatile("nop");  }
#define sccb_delay() {   asm volatile  ("nop" ::); asm volatile  ("nop" ::); asm volatile  ("nop" ::); }
//#define sccb_delay() { uint32_t start = OSCR0; while ( (OSCR0 - start) < 5); }

#endif /* _OV7649SCCB_H */
