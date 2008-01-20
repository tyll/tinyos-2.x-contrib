/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * abstraction for general-purpose I/O.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include "at32uc3b.h"

interface HplAt32uc3bGpioInterrupt
{
  /**
   * Enable an edge based interrupt. Calls to these functions are
   * not cumulative: only the transition type of the last called function
   * will be monitored for.
   *
   * @return SUCCESS if the interrupt has been enabled
   */
  async command error_t enableChangingEdge();
  async command error_t enableRisingEdge();
  async command error_t enableFallingEdge();

  /**
   * Disables an edge interrupt.
   *
   * @return SUCCESS if the interrupt has been disabled
   */
  async command error_t disable();

  /**
   * Gets interrupt status.
   */
  async command bool isInterruptEnabled();
  async command uint8_t getInterruptMode(); // gpio_interrupt_mode_enum_t

  /**
   * Fired when an edge interrupt occurs.
   *
   * NOTE: Interrupts keep running until "disable()" is called
   */
  async event void fired();
  async command void clear();
  /**
   * Returns number of triggered interrupts.
   */
  async command uint32_t getCounter();

  /**
   * Enables/disables glitch filter (if the filter is enabled, the pulse must 
   * be sampled on two subsequent rising clock edges to trigger an interrupt)
   *
   * NOTE: should only be changed when IER is 0, otherwise 
   *       an unintentional interrupt can be triggered
   */
  async command error_t enableGlitchFilter();
  async command error_t disableGlitchFilter();
  async command bool isGlitchFilterEnabled();
}
