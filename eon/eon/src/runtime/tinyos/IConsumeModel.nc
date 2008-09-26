

interface IConsumeModel
{
	command result_t pathDone(uint16_t pathNum, 
							uint8_t state, 
							uint32_t energy);
	
	//predict the amount of energy based on state and number of external events
	//in the next x hours.
  	command uint64_t getConsumePrediction(uint16_t hours, 
  											uint32_t xevents, 
  											uint8_t state,
  											double grade,
										 	uint8_t src); 
  
}
