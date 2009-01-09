#ifndef __context_switch_h__
#define __context_switch_h__
/* 
 * Copyright (c) 2006, Cleveland State University
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Cleveland State University nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE # OF THIS SOFTWARE, EVEN IF ADVISED OF 
 * THE POSSIBILITY OF SUCH DAMAGE.
 */
 
/*
 * Author: William P. McCartney
 * Last modified: Nov 15, 2006
 */

// ---------------
// Summary: This file contains AVR platform-specific routines for TinyThread.
// ---------------

//short int * sp = 0;
//short int * original = 0;

//Push General Purpose Registers
#define PUSH_GPR()         \
  __asm__("push r0");     \
  __asm__("push r1");     \
  __asm__("push r2");     \
  __asm__("push r3");     \
  __asm__("push r4");     \
  __asm__("push r5");     \
  __asm__("push r6");     \
  __asm__("push r7");     \
  __asm__("push r8");     \
  __asm__("push r9");     \
  __asm__("push r10");    \
  __asm__("push r11");    \
  __asm__("push r12");    \
  __asm__("push r13");    \
  __asm__("push r14");    \
  __asm__("push r15");    \
  __asm__("push r16");    \
  __asm__("push r17");    \
  __asm__("push r18");    \
  __asm__("push r19");    \
  __asm__("push r20");    \
  __asm__("push r21");    \
  __asm__("push r22");    \
  __asm__("push r23");    \
  __asm__("push r24");    \
  __asm__("push r25");    \
  __asm__("push r26");    \
  __asm__("push r27");    \
  __asm__("push r28");    \
  __asm__("push r29");    \
  __asm__("push r30");    \
  __asm__("push r31")

#define PUSH_PC()          \
  __asm__("push r0")

#define PUSH_STATUS()         \
  __asm__("push r31");        \
  __asm__("in r31,__SREG__"); \
  __asm__("push r31")

#define POP_PC()            \
  __asm__("pop r0")

#define POP_STATUS()          \
  __asm__("pop r31");         \
  __asm__("out __SREG__,r31");\
  __asm__("pop r31")

//Pop the general purpose registers
#define POP_GPR()         \
  __asm__("pop r31");     \
  __asm__("pop r30");     \
  __asm__("pop r29");     \
  __asm__("pop r28");     \
  __asm__("pop r27");     \
  __asm__("pop r26");     \
  __asm__("pop r25");     \
  __asm__("pop r24");     \
  __asm__("pop r23");     \
  __asm__("pop r22");     \
  __asm__("pop r21");     \
  __asm__("pop r20");     \
  __asm__("pop r19");     \
  __asm__("pop r18");     \
  __asm__("pop r17");     \
  __asm__("pop r16");     \
  __asm__("pop r15");     \
  __asm__("pop r14");     \
  __asm__("pop r13");     \
  __asm__("pop r12");     \
  __asm__("pop r11");     \
  __asm__("pop r10");     \
  __asm__("pop r9");      \
  __asm__("pop r8");      \
  __asm__("pop r7");      \
  __asm__("pop r6");      \
  __asm__("pop r5");      \
  __asm__("pop r4");      \
  __asm__("pop r3");      \
  __asm__("pop r2");      \
  __asm__("pop r1");      \
  __asm__("pop r0")

/*  __asm__("pop r1");      \
  __asm__("pop r0") 
*/

#define SWAP_STACK_PTR(OLD, NEW) \
  __asm__("in %A0, __SP_L__\n\t in %B0, __SP_H__":"=r"(OLD):);\
  __asm__("out __SP_H__,%B0\n\t out __SP_L__,%A0"::"r"(NEW))
 
#define PREPARE_STACK()                               \
  SWAP_STACK_PTR(sys_sp,j_list[id].sp);  \
  __asm__("push %A0\n push %B0"::"r"(job_wrapper));\
  for(i=0;i<34;i++)                                   \
    __asm__("push __zero_reg__");                     \
  SWAP_STACK_PTR(j_list[id].sp, sys_sp)
 
#endif 
