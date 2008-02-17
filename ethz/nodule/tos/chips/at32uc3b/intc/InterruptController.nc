/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

interface InterruptController
{
  async command void registerGpioInterruptHandler(uint32_t gpio, void * handler);
}
