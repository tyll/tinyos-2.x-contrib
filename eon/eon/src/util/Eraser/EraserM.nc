


module EraserM {
  provides {
    interface StdControl;
  }
  uses {
    interface Timer;
	interface PageEEPROM;
    interface Leds;
	interface SendMsg;
	interface InternalFlash;
  }
}
implementation {

#define BUFSIZE	8
#define PAGESIZE 264

bool iflash_done;
uint32_t page;
uint16_t offset;
uint16_t iflash_addr;
uint8_t buffer[BUFSIZE];
TOS_Msg msgbuf;

	task void my_sendTask();

  command result_t StdControl.init() {
  	page = 0;
	offset = 0;
	iflash_addr = 0;
	//iflash_done = FALSE;
	iflash_done = TRUE;
    call Leds.init(); 
    return SUCCESS;
  }


  command result_t StdControl.start() {

    return call Timer.start(TIMER_ONE_SHOT, 1000);
  }

  command result_t StdControl.stop() {
    return call Timer.stop();
  }


  task void my_eraseTask()
  {
  	result_t res;
    
	
	if (page > 2046)
	{
		call Leds.greenOn();
		return;
	}
	
	res = call PageEEPROM.erase(page, TOS_EEPROM_ERASE);
	
	if (res == FAIL)
	{
		call Leds.redToggle();
		post my_eraseTask();
	} else {
		call Leds.yellowToggle();
	}
	
    
  }
  
  event result_t Timer.fired()
  {
  	post my_eraseTask();
	return SUCCESS;
  }
  
  task void my_sendTask()
  {
  		
  }
  
  event result_t PageEEPROM.readDone(result_t res)
    {
		
		return SUCCESS;
	}
	
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		
		//call Timer.start(TIMER_ONE_SHOT, 15);
		return SUCCESS;
	}
	
  event result_t PageEEPROM.eraseDone(result_t res)
    {
		page++;
		//call Timer.start(TIMER_ONE_SHOT, 5);
		post my_eraseTask();
        return (SUCCESS);
    }

    event result_t PageEEPROM.syncDone(result_t result)
    {
        return (SUCCESS);
    }

    event result_t PageEEPROM.computeCrcDone(result_t result, uint16_t crc)
    {
        return (SUCCESS);
    }
	
	event result_t PageEEPROM.writeDone(result_t res)
    {
     
        return (SUCCESS);
    }

    event result_t PageEEPROM.flushDone(result_t res)
    {
        return (SUCCESS);
    }
}


