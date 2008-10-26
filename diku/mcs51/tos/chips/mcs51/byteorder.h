/**
 * Keil byte order
 *  uint16_t big endian (MSB first)
 *  sfr16    little endian (LSB first)
 *
 * Keil stores multi-byte-values as big endian (MSB first, at the
 * lowest address). This means for uint16_t values the high order byte
 * (MSB) must be selected as the address for uint16_t values.
 *
 * sfr16 values the are stored as little endian as such the LSB must
 * be selected as the address of the sfr16 register
 * 
 * It might be worth ignoring the sfr16 definition altogether to avoid
 * confusion, or at least use the following macros to illustrate what
 * is going on - possibly in a compiler agnostic way.
 *
 * http://www.keil.com/support/man/docs/c51/c51_xe.htm
 * http://www.keil.com/support/man/docs/c51/c51_le_sfr16.htm
 *
 */

/**
 * SDCC byte order
 *
 * SDCC apparently stores multibyte values as little endian, it is
 * unclear whether this is the case for sfr16 registers or not.
 *
 * Hopefully someone remembers to chech before compiling with sdcc =].
 *
 * http://sdcc.sourceforge.net/doc/sdccman.pdf
 */

#ifndef _H_BYTEORDER_H_
#define _H_BYTEORDER_H_

#define BIG_ENDIAN
/* #ifdef __KEIL__ */
/* #else */
/* #define LITTLE_ENDIAN */
/* #endif */

//#define _BSWAP_UINT16(word) (((uint8_t*)&word)[0]<<8 | ((uint8_t*)&word)[1])
#define _BSWAP_UINT16(w) ( ((0x00FFu&w)<<8) | ((0xFF00u&w)>>8))
#define _BSWAP_UINT32(l) ( ((0x000000FFul&l)<<24) |\
                           ((0x0000FF00ul&l)<<8)  |\
                           ((0x00FF0000ul&l)>>8)  |\
                           ((0xFF000000ul&l)>>24))


#ifdef BIG_ENDIAN
#define letohs (uint16_t) _BSWAP_UINT16
#define letohl (uint32_t) _BSWAP_UINT32
#define SFR16_TO_UINT16 (uint16_t) _BSWAP_UINT16
#define UINT16_TO_SFR16 (sfr16) _BSWAP_UINT16
#else

/* This warning shows up in Nesc - so maybe it should be defined in
   the makefile or something

#warning "This code probably will not work without the Keil Compiler."
*/
#define letohs(w) w
#define letohl(w) w
#define SFR16_TO_UINT16(w) w 
#define UINT16_TO_SFR16(w) w
#endif

#endif //_H_BYTEORDER_H_
