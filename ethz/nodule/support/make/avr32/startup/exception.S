/* $Id$ */

/* author: Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

/* modified version of newlib-1.14.0.atmel.1.0.0/newlib/libc/sys/avr32/exception.S */

/* modified: moved interrupt stuff to interrupt.S, align is not 9 */

#include <avr32/io.h>
#include <sys/sysregs.h>

.section  .exception,"ax"
.align    3
.global   _evba
_evba:
.org      AVR32_EVBA_OFFSET_UNRECOVERABLE
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_TLB_MULTIPLE
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_BUS_ERROR_DATA
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_BUS_ERROR_INSTR
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_NMI
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_INSTR_ADDR
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_ITLB_PROT
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_BREAKPOINT
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_ILLEGAL_OPCODE
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_UNIMPLEMENTED
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_PRIVILEGE_VIOL
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_FLOATING_POINT /* UNUSED ON AVR32UC */
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_COP_ABSENT /* UNUSED ON AVR32UC */
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_DATA_ADDR_R
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_DATA_ADDR_W
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_DTLB_PROT_R
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_DTLB_PROT_W
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_DTLB_MODIFIED /* UNUSED ON AVR32UC */
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_ITLB_MISS
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_DTLB_MISS_R
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_DTLB_MISS_W
  pushm   r8-r9, r10, r11, r12, lr
  rjmp    _handle_exception
.org      AVR32_EVBA_OFFSET_SCALL
  pushm   r4-r7, r8-r9, r10, r11, r12, lr
  lda.w   r4, handle_scall
  icall   r4
  popm    r4-r7, r8-r9, r10, r11, r12, lr
  rets

_handle_exception:
  mfsr    r12, SYSREG_ECR
  lsl     r12, 2 /* Shift to get evba offset. */
  lddsp   r11, sp[4+6*4]
  mcall   handle_exception
  stdsp   sp[4+6*4], r12
  popm    r8-r9, r10, r11, r12,lr
  rete
