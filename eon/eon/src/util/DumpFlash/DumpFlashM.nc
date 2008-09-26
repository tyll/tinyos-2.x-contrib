


module DumpFlashM {
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

    return call Timer.start(TIMER_ONE_SHOT, 10000);
  }

  command result_t StdControl.stop() {
    return call Timer.stop();
  }


  event result_t Timer.fired()
  {
    call Leds.redToggle();
	
	if (!iflash_done)
	{
		if (SUCCESS == call InternalFlash.read((void*)iflash_addr, buffer, BUFSIZE))
		{
			post my_sendTask();
		}
			
	} else {
		call PageEEPROM.read(page, offset, buffer, BUFSIZE);
	}
    return SUCCESS;
  }
  
  task void my_sendTask()
  {
  		result_t sendres;
		
  		memcpy(msgbuf.data, &iflash_done, sizeof(bool));
		if (iflash_done)
		{	
			memcpy(msgbuf.data+sizeof(bool), &page, sizeof(page));
			memcpy(msgbuf.data+sizeof(page)+sizeof(bool), &offset, sizeof(offset));
		} else {
			memcpy(msgbuf.data+sizeof(bool), &iflash_addr, sizeof(iflash_addr));
		}
		memcpy(msgbuf.data+sizeof(page)+sizeof(offset)+sizeof(bool), buffer, BUFSIZE);
			
		sendres = call SendMsg.send(TOS_UART_ADDR, sizeof(bool)+sizeof(page)+sizeof(offset)+BUFSIZE, &msgbuf);	
  }
  
  event result_t PageEEPROM.readDone(result_t res)
    {
		
		
		if (res == SUCCESS)
		{
			
			post my_sendTask();	
			
			
		}
		call Leds.redToggle();
		return SUCCESS;
	}
	
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		if (success == SUCCESS)
		{
			if (!iflash_done)
			{
				iflash_addr += BUFSIZE;
				if (0xFFF - iflash_addr < (BUFSIZE*2))// don't read the end
				{
					iflash_done = TRUE;
				}
			} else { 
				offset += BUFSIZE;
				if (offset >= PAGESIZE-1)
				{
					page++;
					offset = 0;
				}
			}
		}
		call Timer.start(TIMER_ONE_SHOT, 15);
		return SUCCESS;
	}
	
  event result_t PageEEPROM.eraseDone(result_t res)
    {
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


