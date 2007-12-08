/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

interface SystemLed
{
  /**
   * Turn on system LED.
   */
  async command void on();

  /**
   * Turn off system LED.
   */
  async command void off();

  /**
   * Toggle system LED.
   */
  async command void toggle();

  /**
   * Get the current system LED setting.
   */
  async command bool get();
}
