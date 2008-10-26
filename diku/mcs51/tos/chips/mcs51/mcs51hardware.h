/*
 * Copyright (c) 2007 University of Copenhagen
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * Ported to 8051 by Martin Leopold, Sidsel Jensen & Anders Egeskov Petersen, 
 *                   Dept of Computer Science, University of Copenhagen
 *
 *  @author Martin Leopold <leopold@diku.dk>
 *  @author Sidsel Jensen,
 *  @authro Anders Egeskov Petersen
 */


#ifndef _H_mcs51hardware_H
#define _H_mcs51hardware_H

#include <io8051.h>
// At some point someone is probably going to use these from avrlibc =]

#ifndef _BV
#define _BV(bit) (1 << (bit))
#endif

// Borrow these from atm128hardware
// Using these for IO seems rather silly as IO ports are bit accessible as
// Px_y (where x is the port and y is the pin)
#define SET_BIT(port, bit)    ((port) |= _BV(bit))
#define CLR_BIT(port, bit)    ((port) &= ~_BV(bit))
#define READ_BIT(port, bit)   (((port) & _BV(bit)) != 0)
#define FLIP_BIT(port, bit)   ((port) ^= _BV(bit))

// Define the input/output direction of the Px_DIR registers
// this is the classic 8051 implementation, some variants
// have other definitions

#define MAKE_IO_PIN_OUTPUT(dir_reg, pin) dir_reg |=  _BV(pin)
#define MAKE_IO_PIN_INPUT(dir_reg, pin)  dir_reg &= ~_BV(pin)

// Test whether an IO pin is set to input or output
#define IS_IO_PIN_OUTPUT(dir_reg, pin) dir_reg | _BV(pin)
#define IS_IO_PIN_INPUT(dir_reg, pin)  !(dir_reg & _BV(pin))

/*
 * We need slightly different defs than SIGNAL, INTERRUPT
 * See gcc manual for explenation of gcc-attributes
 * See nesC Language Reference Manual for nesc attributes
 *
 * signal: Interrupts are disabled inside function.
 * interrupt: Sets up interrupt vector, but doesn't disable interrupts
 * spontaneous: nesc attribute to indicate that there are "inisible" calls to this
 *              function i.e. interrupts

 * It seems that 8051 compilers only define the interrupt keyword (not
 * signal). It is unclear wether interrupts are disabled or enabled by
 * default.

 * We use AVR-like syntax so the mangle script looks for something like:
 *    void __vector_9() __attribute((interrupt))) {
 *
 * Which is mangled to
 *    void __vector interrupt 9 () {
 *
 * NOTE: This means that the interrupt number is passed as part of the
 * name - so don't change it! This name is further passed to the
 * CIL-inliner script in order for it to leave it there.
 */

// Interrupt: interrupts are enabled (probably =)
#define MCS51_INTERRUPT(signame) \
void signame() __attribute((interrupt, spontaneous, C))

// atomic statement runtime support
typedef uint8_t __nesc_atomic_t;

inline void __nesc_disable_interrupt() { EA=0; }
inline void __nesc_enable_interrupt()  { EA=1; }
    
inline __nesc_atomic_t __nesc_atomic_start(void) __attribute((spontaneous)) {
  __nesc_atomic_t tmp = EA;
  EA = 0; 
  return tmp;
}

inline void __nesc_atomic_end(__nesc_atomic_t oldSreg) __attribute__((spontaneous)) {
  EA = oldSreg;
}

#endif //_H_mcs51hardware_H
