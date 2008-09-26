

interface ILoadModel
{
	command result_t pathDone(uint16_t pathNum);
	
	//predict the number of events that will occur at non-timed events
	//in the next t minutes.
  command int32_t getLoadPrediction(uint16_t hours); 
  
}
