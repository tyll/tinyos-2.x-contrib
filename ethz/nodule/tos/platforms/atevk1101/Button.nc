/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

interface Button
{
  async command void enable();

  async command void disable();

  async event void pressed();
}
