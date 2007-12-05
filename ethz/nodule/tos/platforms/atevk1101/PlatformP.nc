/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

module PlatformP
{
  provides interface Init;
  uses interface Init as LedsInit;
}
implementation
{
  command error_t Init.init()
  {
    call LedsInit.init();

    return SUCCESS;
  }

  default command error_t LedsInit.init() { return SUCCESS; }
}
