

interface IConsumeModel
{
	command result_t pathDone(uint16_t pathNum, 
							uint8_t state, 
							uint32_t energy);
	
	//predict the amount of energy based on state and number of external events
	//in the next t hours.
  	command uint32_t getComsumePrediction(uint16_t hours, 
  											uint32_t xevents, 
  											uint8_t state,
  											bool min); 
  
}
