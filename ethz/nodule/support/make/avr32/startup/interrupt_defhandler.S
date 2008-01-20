/* $Id$ */

/* author: Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

// this code will actually block the MCU, as long as the interrupt flag is not cleared

.global   handle_interrupt
.weak     handle_interrupt
handle_interrupt:
  retal   0
