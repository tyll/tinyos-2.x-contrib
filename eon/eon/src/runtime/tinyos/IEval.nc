

interface IEval
{
	  	
	command result_t reeval_energy_level();
	event result_t reeval_done(uint8_t state, double grade);
	
	command result_t reportPathDone(uint16_t pathnum, uint8_t state, uint32_t energy);
	//command uint8_t getstate();
	//command uint8_t 
}
