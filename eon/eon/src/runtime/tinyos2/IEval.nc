

interface IEval
{
	  	
	command error_t reeval_energy_level();
	event void reeval_done(uint8_t state, double grade);
	
	command error_t reportPathDone(uint16_t pathnum, uint8_t state, uint32_t energy);
	//command uint8_t getstate();
	//command uint8_t 
}
