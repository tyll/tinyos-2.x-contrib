#ifndef __context_switch_h__
#define __context_switch_h__

#define GET_SP(sp) {asm volatile("in %A0, __SP_L__\n\t in %B0, __SP_H__\n\t" : "=r" (sp) : );}

#define CONTEXT_SWITCH_PREAMBLE(FROM, TO)			\
   {						\
      asm volatile("in %A0, __SP_L__\n\t in %B0, __SP_H__\n\t" : "=r" (contexts[FROM].sp) : );		\
	  asm volatile("out __SP_H__, %B0\n\t out __SP_L__, %A0\n\t" :: "r" (stack_addr) );				\
	  asm volatile("push %A0\n\t push %B0\n\t" :: "r" (preemption_handler) );			\
							\
      for(idex = 0; idex < 31; idex++)				\
	asm volatile("push __zero_reg__\n\t" ::);	\
    asm volatile("in %A0, __SP_L__\n\t in %B0, __SP_H__\n\t" : "=r" (contexts[TO].sp) : );			\
							\
      asm volatile("out __SP_H__, %B0\n\t out __SP_L__, %A0\n\t" :: "r" (contexts[FROM].sp) );		\
	}

/** @brief save the current thread's context to the stack
 * Save all the registers
 * Save SREG
 * Push the stack pointer
 */
#define PUSH_CONTEXT(ID)			\
   {					\	
      asm volatile("push r24\n\t in r24, __SREG__\n\t cli\n\t push r24\n\t");					\
      asm volatile(				\
	 "push r31\n\t"				\
	 "push r30\n\t"				\
	 "push r29\n\t"				\
	 "push r28\n\t"				\
	 "push r27\n\t"				\
	 "push r26\n\t"				\
	 "push r25\n\t"				\
	 "push r23\n\t"				\
	 "push r22\n\t"				\
	 "push r21\n\t"				\
	 "push r20\n\t"				\
	 "push r19\n\t"				\
	 "push r18\n\t"				\
	 "push r17\n\t"				\
	 "push r16\n\t"				\
	 "push r15\n\t"				\
	 "push r14\n\t"				\
	 "push r13\n\t"				\
	 "push r12\n\t"				\
	 "push r11\n\t"				\
	 "push r10\n\t"				\
	 "push r9\n\t"				\
	 "push r8\n\t"				\
	 "push r7\n\t"				\
	 "push r6\n\t"				\
	 "push r5\n\t"				\
	 "push r4\n\t"				\
	 "push r3\n\t"				\
	 "push r2\n\t"				\
	 );					\
      asm volatile(				\
	 "in %A0, __SP_L__\n\t in %B0, __SP_H__\n\t" : "=r" (contexts[ID].sp) : );	\
  }

/** @brief retrieve a thread and context from the stack
 * Restore the stack pointer
 * Restore SREG
 * Restore the other registers
 */
#define POP_CONTEXT(ID)			\
   {						\
      asm volatile("out __SP_H__, %B0\n\t out __SP_L__, %A0\n\t" :: "r" (contexts[ID].sp));		\
      asm volatile(	"pop r2\n\t"				\
	 "pop r3\n\t"				\
	 "pop r4\n\t"				\
	 "pop r5\n\t"				\
	 "pop r6\n\t"				\
	 "pop r7\n\t"				\
	 "pop r8\n\t"				\
	 "pop r9\n\t"				\
	 "pop r10\n\t"				\
	 "pop r11\n\t"				\
	 "pop r12\n\t"				\
	 "pop r13\n\t"				\
	 "pop r14\n\t"				\
	 "pop r15\n\t"				\
	 "pop r16\n\t"				\
	 "pop r17\n\t"				\
	 "pop r18\n\t"				\
	 "pop r19\n\t"				\
	 "pop r20\n\t"				\
	 "pop r21\n\t"				\
	 "pop r22\n\t"				\
	 "pop r23\n\t"				\
	 "pop r25\n\t"				\
	 "pop r26\n\t"				\
	 "pop r27\n\t"				\
	 "pop r28\n\t"				\
	 "pop r29\n\t"				\
	 "pop r30\n\t"				\
	 "pop r31\n\t"				\
	 "pop r24\n\t"				\
	 "out __SREG__, r24\n\t"		\
	 "pop r24\n\t"				\
	 );					\
   }

#define CONTEXT_DIFF 50
#endif 
