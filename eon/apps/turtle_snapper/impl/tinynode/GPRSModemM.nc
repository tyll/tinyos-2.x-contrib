	


module GPRSModemM
{
	provides
	{
		interface StdControl;
		interface GPRS;
	}
	uses
	{
		interface HPLUART;
		interface Timer;
		interface Timer as OKTimer;
		interface Leds;
	}
}
implementation
{

#define RESPONSE_LENGTH 500
#define GPRS_RETRIES	5
	
norace char *buffer = NULL;
norace char *match = NULL;
bool busy = FALSE;
bool waitforok;
norace uint32_t timeoutms;

norace int numsent;
/*	int msg_count;
	int record_count;
	norace int cmdidx;
	int cmdc;
	int msgidx;
	int failure;
	bool sending;
	norace bool endc = FALSE;
	int retries;
*/


norace char response[RESPONSE_LENGTH];
norace int response_idx;


							
	command result_t StdControl.init ()
	{
		call HPLUART.init();
		call Leds.init();
		response[0] = 0;
		response_idx = 0;
		
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		//TOSH_MAKE_P41_OUTPUT();
		//TOSH_SET_P41_PIN();	
		TOSH_MAKE_P12_OUTPUT();
		TOSH_SET_P12_PIN();	
		
		busy = TRUE;
		call Timer.start(TIMER_ONE_SHOT, 15000L);
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		
		//TOSH_CLR_P41_PIN();	
		TOSH_CLR_P12_PIN();
		call Timer.stop();
		call OKTimer.stop();
		busy = FALSE;
		return SUCCESS;
	}

	
	
	task void SendCommandChar()
	{
		
		call HPLUART.put(buffer[numsent]);
	}
	
	command result_t GPRS.ATCmd(char *cmd, char *mtch, uint32_t waitms)
	{
		if (busy) return FAIL;
		busy = TRUE;
		buffer = cmd;
		if (mtch != NULL && strlen(mtch)==0) 
		{
			match = NULL;
		} else {
			match = mtch;
		}
		timeoutms = waitms;
		numsent = 0;
		post SendCommandChar();
		response_idx = 0;
		response[0] = 0;
		return SUCCESS;
	}
	
	task void startOkTimer()
	{
		call OKTimer.start(TIMER_ONE_SHOT, timeoutms);
	}
	
	async event result_t HPLUART.putDone()
	{
		numsent++;
		if (buffer[numsent] == 0)
		{
			post startOkTimer();
		} else {
			post SendCommandChar();
		}
		return SUCCESS;
	}
	
	
	
	void IAmDone(result_t success)
 	{
		if (!busy) return;
		signal GPRS.ATCmdDone(success, response);
		response_idx = 0;
		response[0] = 0;
	    busy = FALSE;
	}
	
	task void SuccessTask()
	{
		IAmDone(SUCCESS);
	}
	
	task void allDoneTask()
	{
		//call Leds.redToggle();
		call OKTimer.stop();
		post SuccessTask();
	}
	void DoneYet()
	{
		if (match != NULL)
		{
			if (strstr(response,match) != 0)
			{
				post allDoneTask();
			}
		}
	}
	
	event async result_t HPLUART.get(uint8_t data) 
	{
		
		if ((data!=0) && (response_idx < RESPONSE_LENGTH-2)) //reserve last byte for null-char
		{
			response[response_idx] = data;
			response[response_idx+1] = 0;
			response_idx++;
			
		}
		DoneYet();
		return SUCCESS;
	}
	
	
	
	event result_t OKTimer.fired()
	{
		IAmDone((match == NULL ? SUCCESS : FAIL));
		return SUCCESS;
	}
	
	event result_t Timer.fired()
	{
		busy = FALSE;
		response_idx = 0;
		response[0] = 0;
		signal GPRS.ready();
		
		return SUCCESS;
	}

}
