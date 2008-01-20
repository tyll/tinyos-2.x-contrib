/* $Id$ */

/* author: Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

// untested

.global   handle_exception
.global   handle_scall
.weak     handle_exception
.weak     handle_scall
handle_exception:
handle_scall:
  retal   0
