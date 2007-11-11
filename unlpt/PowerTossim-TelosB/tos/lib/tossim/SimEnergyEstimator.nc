interface SimEnergyEstimator {

	command void rxEnergy(sim_time_t diff);
	command void txEnergy(uint8_t bytes,float current,uint32_t baudrate);
	command void rxPacketEnergy(uint8_t bytes, float current, uint32_t baudrate);
	command void radioIdleEnergy(sim_time_t diff);
	command void Stm25pWrite(uint8_t bytes);
	command void Stm25pRead(uint8_t bytes);
	command void Msp430ActiveRadio(sim_time_t diff);
	command void Msp430ActiveNoRadio(sim_time_t diff);

}
