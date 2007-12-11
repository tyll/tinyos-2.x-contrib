/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * abstraction for general-purpose I/O.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include "at32uc3b.h"

interface HplAt32uc3bGeneralIO
{
  /**
   * Set pin to high.
   */
  async command void set();

  /**
   * Set pin to low.
   */
  async command void clr();

  /**
   * Toggle pin status.
   */
  async command void toggle();

  /**
   * Read pin value.
   *
   * @return TRUE if pin is high, FALSE otherwise.
   */
  async command bool get();

  /**
   * Set pin direction to input.
   */
  async command void makeInput();

  async command bool isInput();

  /**
   * Set pin direction to output.
   */
  async command void makeOutput();

  async command bool isOutput();

  /**
   * Set pin for a specific peripheral functionality.
   */
  async command void selectPeripheralFunc();

  async command bool isPeripheralFunc();

  async command void setPeripheralFunc(uint8_t peripheral_func);

  async command uint8_t getPeripheralFunc();

  /**
   * Set pin for I/O functionality.
   */
  async command void selectIOFunc();

  async command bool isIOFunc();

  /**
   * Enable/disable pullup on pin.
   */
  async command void enablePullup();

  async command void disablePullup();

  async command bool isPullup();

  /**
   * Enable/disable open drain on pin.
   */
  async command void enableOpenDrain();

  async command void disableOpenDrain();

  async command bool isOpenDrain();

}
