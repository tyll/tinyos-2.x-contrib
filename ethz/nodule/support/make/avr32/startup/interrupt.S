/* $Id$ */

/* author: Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

.section  .interrupt,"ax"
.align    1
.global   _int
_int:
  rete
