/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

module PlatformP
{
  provides interface Init;
  uses interface Init as LedsInit;
  uses interface Init as InterruptInit;
}
implementation
{
  command error_t Init.init()
  {
    call InterruptInit.init();

    call LedsInit.init();

    return SUCCESS;
  }

  default command error_t InterruptInit.init() { return SUCCESS; }

  default command error_t LedsInit.init() { return SUCCESS; }
}
