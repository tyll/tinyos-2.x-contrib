

module SequenceMgrM {

  provides {
		interface StdControl;
		command uint16_t getNextSeq();
	}

  uses {
		interface InternalFlash;
		interface Timer;
  }
  
}
implementation {
	uint16_t seq_num;
	

#define SEQ_SAVE_INTERVAL (60L * 60L * 1024L * 5L) //every 5 hours
#define IFLASH_SEQ_START_ADDR 0x1004
#define IFLASH_SEQ_VALID_ADDR 0x1008
#define VALID_STR  0xbe

  command result_t StdControl.init() {
    result_t res;
	
  	seq_num = 0;
	
    return SUCCESS;
  }

  command result_t StdControl.start() 
  { 
  	uint8_t valid;
	uint16_t tmp;
	result_t res;
	
	seq_num = 0;
	
	res = call InternalFlash.read((void*)IFLASH_SEQ_VALID_ADDR, &valid, 1);
	if (valid == VALID_STR)
	{
		call InternalFlash.read((void*)IFLASH_SEQ_START_ADDR, &seq_num, 2);
	}
    return call Timer.start(TIMER_REPEAT, SEQ_SAVE_INTERVAL);
  }
  command result_t StdControl.stop() {
  	call Timer.stop();
  	return SUCCESS;
  }

  event result_t Timer.fired()
	{
		uint8_t valid = VALID_STR;
		call InternalFlash.write((void*)IFLASH_SEQ_VALID_ADDR, &valid, 1);
		call InternalFlash.write((void*)IFLASH_SEQ_START_ADDR, &seq_num, 2);
		return SUCCESS;
  	}

 
	
	command uint16_t getNextSeq()
	{
		uint16_t seq;
		
		//always called from tasks.  Therefore, no need for atomic
		{
			seq = seq_num;
			seq_num++;
		}
		return seq;
	}

	
}

