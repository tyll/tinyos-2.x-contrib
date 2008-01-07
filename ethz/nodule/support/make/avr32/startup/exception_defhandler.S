/* $Id$ */

/* author: Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

.global   handle_exception
.global   handle_scall
.weak     handle_exception
.weak     handle_scall
handle_exception:
handle_scall:
  rjmp    0
