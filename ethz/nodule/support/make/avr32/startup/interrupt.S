/* $Id$ */

/* author: Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

.section  .interrupt,"ax"
.align    3
.global   _int0
.global   _int1
.global   _int2
.global   _int3
.irp      priority,0,1,2,3
_int\priority:
  pushm   lr
  mov     r12, \priority
  call    handle_interrupt
  popm    lr
  rete	
.endr
