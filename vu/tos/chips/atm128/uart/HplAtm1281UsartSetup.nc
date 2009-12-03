interface HplAtm1281UsartSetup {

  async command void setMode(uint8_t mode, uint8_t charSize, uint8_t parity, uint8_t stopBits);

  async command uint32_t computeBaudRate(uint8_t mode, uint32_t f_osc, uint16_t ubrr);

  async command uint16_t computeUBRR(uint8_t mode, uint32_t f_osc, uint32_t baudRate);

  async command uint16_t computeByteTimeMicro(uint8_t mode, uint8_t charSize, uint8_t parity, uint8_t stopBits, uint32_t baudRate);
}
