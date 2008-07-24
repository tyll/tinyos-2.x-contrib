interface ADE7753 {

	command error_t getReg(uint8_t regAddr, uint8_t len);
	async event void getRegDone( error_t error, uint8_t regAddr, uint32_t val, uint16_t len);

  command error_t setReg( uint8_t regAddr, uint8_t len, uint32_t val);
  async event void setRegDone( error_t error , uint8_t regAddr, uint32_t val, uint16_t len);

//  async event void alertThreshold();

}
