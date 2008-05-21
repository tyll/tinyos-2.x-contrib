// $Id$

/* "Copyright (c) 2000-2003 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

// @author Cory Sharp <cssharp@eecs.berkeley.edu>

#ifndef _H_hcs08gb60_interrupts_h
#define _H_hcs08gb60_interrupts_h

#define INTERRUPT_RESET 0
#define INTERRUPT_SWI 1
#define INTERRUPT_IRQ 2
#define INTERRUPT_LVD 3
#define INTERRUPT_ICG 4
#define INTERRUPT_TPM1CH0 5
#define INTERRUPT_TPM1CH1 6
#define INTERRUPT_TPM1CH2 7
#define INTERRUPT_TPM1OVF 8
#define INTERRUPT_TPM2CH0 9
#define INTERRUPT_TPM2CH1 10
#define INTERRUPT_TPM2CH2 11
#define INTERRUPT_TPM2CH3 12
#define INTERRUPT_TPM2CH4 13
#define INTERRUPT_TPM2OVF 14
#define INTERRUPT_SPI 15
#define INTERRUPT_SCI1ERR 16
#define INTERRUPT_SCI1RX 17
#define INTERRUPT_SCI1TX 18
#define INTERRUPT_SCI2ERR 19
#define INTERRUPT_SCI2RX 20
#define INTERRUPT_SCI2TX 21
#define INTERRUPT_KEYBOARD 22
#define INTERRUPT_ATD 23
#define INTERRUPT_IIC 24
#define INTERRUPT_RTI 25

#define HCS08_SIGNAL(signame) \
interrupt INTERRUPT_##signame void signal_##signame()

#if !defined(MANGLED_NESC_APP_C)
#pragma INLINE
void hcs08_disable_interrupt() { asm("sei"); }
#pragma INLINE
void hcs08_enable_interrupt() { asm("cli"); }
#endif//!defined(MANGLED_NESC_APP_C)

#endif//_H_hcs08gb60_interrupts_h

