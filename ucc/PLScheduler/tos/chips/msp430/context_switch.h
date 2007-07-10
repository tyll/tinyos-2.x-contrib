
#ifndef __context_switch_h__
#define __context_switch_h__
#include "TaskPriority.h"

#define GET_SP(sp) {asm volatile("mov.w r1, %0\n\t"	:"=r" (sp) : );	}

#define CONTEXT_SWITCH_PREAMBLE(FROM, TO)                  \
{                                                  \
   asm volatile("mov.w r1, %0\n\t"                 \
		:"=r"(contexts[FROM].sp) : );    \
                                                   \
   asm volatile("mov.w %0, r1\n\t"                 \
		:: "r"(stack_addr) );              \
                                                   \
   asm volatile("push %0\n\t"                      \
        ::"r"(preemption_handler));					\
                                                   \
   for(idex = 0; idex < 13; idex++)                         \
      asm volatile("push r3\n\t");                 \
                                                   \
   asm volatile("mov.w r1, %0\n\t"                 \
		:"=r"(contexts[TO].sp) : );         \
                                                   \
   asm volatile("mov.w %0, r1\n\t"                 \
		::"r"(contexts[FROM].sp) ); \
                                                   \
}


#define PUSH_CONTEXT(ID)			\
   {						\
      asm volatile(				\
	 "push r2\n\t"				\
	 "dint\n\t"				\
	 );					\
      asm volatile(				\
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
	 );					\
      asm volatile(				\
         "mov.w r1, %0\n\t"                     \
         :"=r"(contexts[ID].sp) : );	\
   }

#define POP_CONTEXT(ID)                      \
{                                               \
   asm volatile("mov.w %0, r1\n\t"              \
		::"r"(contexts[ID].sp));    \
                                                \
   asm volatile(                                \
      "pop r4\n\t"                              \
      "pop r5\n\t"                              \
      "pop r6\n\t"                              \
      "pop r7\n\t"                              \
      "pop r8\n\t"                              \
      "pop r9\n\t"                              \
      "pop r10\n\t"                             \
      "pop r11\n\t"                             \
      "pop r12\n\t"                             \
      "pop r13\n\t"                             \
      "pop r14\n\t"                             \
      "pop r15\n\t"                             \
      );                                        \
                                                \
   asm volatile("pop r2\n\t");                  \
   asm volatile("eint\n\t");                    \
}

#define CONTEXT_DIFF 50
#endif
