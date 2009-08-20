
interface PendingBit {

  /**
   * The amount of time that will pass until the radio is set back to normal
   * after a packet is received with the 'packet pending' bit set.
   * @param bms Time in binary ms
   */
  command void setDuration(uint16_t bms);
  
  /**
   * Wakeup interval of 0 wakes the radio up completely until set back to normal
   * An interval > 0 will cause the radio to duty cycle at that interval
   * until the radio gets set back to normal.
   * @param bms Local wakeup interval duration in binary ms
   */
  command void setLocalWakeupInterval(uint16_t bms);
  
  /**
   * Go into pending bit abnormal mode.
   */
  command void forcePendingBitMode();

}
