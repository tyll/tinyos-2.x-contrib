interface HplAtm1281UsartUtil {
/*
  async command void setMode(uint8_t mode, uint8_t charSize, uint8_t parity, uint8_t stopBits);

  async command uint32_t computeBaudRate(uint8_t mode, uint32_t f_osc, uint16_t ubrr);

  async command uint16_t computeUBRR(uint8_t mode, uint32_t f_osc, uint32_t baudRate);

  async command uint16_t computeByteTimeMicro(uint8_t mode, uint8_t charSize, uint8_t parity, uint8_t stopBits, uint32_t baudRate);
*/
  async command void flushRxBuffer();

  async command bool isRxComplete();

  async command bool isTxInProgress();

  async command bool isRxOrTxInProgress();

  async command uint8_t getRxErrorFlags();
  
  
  async command void enableRxCompleteInterrupt();
  async command void disableRxCompleteInterrupt();
  async command bool isRxCompleteInterruptEnabled();
  async command void enableTxBufferEmptyInterrupt();
  async command void disableTxBufferEmptyInterrupt();
  async command bool isTxBufferEmptyInterruptEnabled();
  
  async command void tx(uint8_t b);
  
}
