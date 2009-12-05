interface SimxTxPower {
  
  /**
   * Get transmission power setting.
   *
   * WARNING: The value returned is global.
   *
   */
  async command uint8_t getPower();

  /**
   * Set transmission power. Valid ranges are
   * between 0 and 31.
   *
   * WARNING: This change will be in effect until it is reverted; that
   * is, changing the transmission power causes a global affect.
   *
   */
  async command uint8_t setPower(uint8_t power);
  
}
