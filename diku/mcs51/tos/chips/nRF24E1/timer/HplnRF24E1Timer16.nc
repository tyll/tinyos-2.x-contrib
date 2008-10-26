/**
 * This interface controls the 16 bit timer 2
 * This interface is not used.
 */

#include <nRF24E1Timer.h>

interface HplnRF24E1Timer16 {

  /** 
   * Get the current time.
   * @return  the current time
   */
  async command uint16_t get();

  /** 
   * Set the current time.
   * @param t     the time to set
   */
  async command void set( uint16_t t );
/*
  async command void enableCompare0();
  async command void enableCompare1();
  async command void enableCompare2();

  async command void disableCompare0();
  async command void disableCompare1();
  async command void disableCompare2();
*/
  /** 
   * Get the value of the compare register
   * @return value of compare register
   */
/*
  async command uint16_t getCompare0();
  async command uint16_t getCompare1();
  async command uint16_t getCompare2();
*/
  /** 
   * Set the value of the compare register
   * @return value of compare register to set
   */

/*
  async command void setCompare0( uint16_t t );
  async command void setCompare1( uint16_t t );
  async command void setCompare2( uint16_t t );
*/
  /** 
   * Set the timer mode
   */
   
  async command void setMode( enum nRF24E1_timer2_mode_t mode );

  /** 
   * Get the timer mode
   * @return timer mode
   */

  async command enum nRF24E1_timer2_mode_t getMode();

  /* 
   * Set the T1IE flag to enable/disable interrupts altogether:
   * capture, compare and overflow. Remember to set the overflow
   * interrupt mask as well if overflow interrupts are desired.
   *
   */

  async command void enableEvents();
  async command void disableEvents();

  /* 
   * Set/clear the overflow interrupt enable flag T1CLT.OVFIM.  No
   * interrupts will be generated on overflow unless this flag is set.
   */

  async command void enableOverflow();
  async command void disableOverflow();

  /*
   * Check/clear the interrupt status flag corresponding to the mask
   * from the enum cc2430_timer1_if
   *
   * @param if_mask Mask to check/clear bit in T1CTL
   */
/*
  async command bool isIfPending(enum cc2430_timer1_if_t if_mask);
  async command void clearIf(enum cc2430_timer1_if_t if_mask);
*/
  /** 
   * Set the prescaler (clock divider) according to the predefined
   * division values. See CC2430Timer.h.
   *
   * @param scale One of 4 predefined prescaler settings.
   */

  async command void setScale( enum nRF24E1_timer2_prescaler_t scale );

  /** 
   * Get prescaler setting.
   * @return  Prescaler setting of clock -- see CC2430Timer.h
   */

  async command enum nRF24E1_timer2_prescaler_t getScale();

  /** 
   * The timer has fired - the type of interrupt must be checked in
   * T1CTL
   *
   */
  async event void fired();

}
