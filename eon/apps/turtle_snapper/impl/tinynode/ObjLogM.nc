


module ObjLogM {
  provides {
    interface StdControl;
	interface ObjLog[uint8_t id];
  }
  uses {
	interface PageEEPROM;
	interface InternalFlash;
  }
}
implementation {

#define IFLASH_LOG_START_ADDR 0x0010
#define IFLASH_LOG_VALID_ADDR 0x0009

#define NUM_LOGS 3
#define MAX_OBJ 150
#define MAX_BUF (MAX_OBJ+6)

#define MY_PAGE_SIZE (TOS_EEPROM_PAGE_SIZE - 8)

struct {
	uint16_t start_page;
	uint16_t end_page;
	uint16_t end_offset;
	uint16_t read_page;
	uint16_t read_offset;
} the_log[NUM_LOGS];

uint16_t part_start_page[NUM_LOGS];	
uint16_t part_end_page[NUM_LOGS];

bool dirty;
uint8_t writecount;

uint8_t __writebuf[MY_PAGE_SIZE];
uint8_t __readbuf[MY_PAGE_SIZE];

int state;
uint16_t __logid;
uint16_t __ifid;
uint16_t __numbytes;
int __retries = 0;

enum
{
	IDLE,
	APPEND,
	READ,
	SEEK,
	DELETE,
};

void advanceEndPage(int logid);

void advanceStartPage(int logid, bool moveend)
{
	bool moveRead = FALSE;
	
	if (moveend && the_log[logid].start_page == the_log[logid].end_page)
	{
		advanceEndPage(logid);
	}
	
	if (the_log[logid].start_page == the_log[logid].read_page)
	{
		moveRead = TRUE;
	}

	the_log[logid].start_page++;
	if (the_log[logid].start_page > part_end_page[logid])
	{
		the_log[logid].start_page = part_start_page[logid];
	}
	
	if (moveRead)
	{
		the_log[logid].read_page = the_log[logid].start_page;
		the_log[logid].read_offset = 0;
	}
}
void advanceEndPage(int logid)
{
       bool readmove = FALSE;
       if (the_log[logid].read_page == the_log[logid].end_page &&
               the_log[logid].read_offset == the_log[logid].end_offset)
       {
               readmove = TRUE;
       }
       the_log[logid].end_page++;
       if (the_log[logid].end_page > part_end_page[logid])
       {
               the_log[logid].end_page = part_start_page[logid];
       }
       the_log[logid].end_offset = 0;
       
       if (the_log[logid].end_page == the_log[logid].start_page)
       {
               advanceStartPage(logid, FALSE);
       }
       if (readmove)
       {
               the_log[logid].read_page = the_log[logid].end_page;
               the_log[logid].read_offset = the_log[logid].end_offset;
       }
}

	task void SaveLog()
	{
		int8_t valid;
		valid = 0xAB;
		call InternalFlash.write((void*)IFLASH_LOG_VALID_ADDR, &valid, sizeof(valid));
		call InternalFlash.write((void*)IFLASH_LOG_START_ADDR, (char*)the_log, sizeof(the_log));
		writecount = 0;
	}

  command result_t StdControl.init() {
  	int i;
	uint8_t valid;
	result_t res;
  
	writecount = 0;

	dirty = FALSE;
	state = IDLE;
//partition the flash -- I know I know it isn't pretty
	part_start_page[0] = 2;
	part_end_page[0] = 1500;
//	part_end_page[0] = 40;
	
	part_start_page[1] = 1501;
//	part_start_page[1] = 41;
	part_end_page[1] = 1800;
	
	part_start_page[2] = 1801;
	part_end_page[2] = 2047;
	
	if (TOS_LOCAL_ADDRESS == 0)
	{
		//special formatting for the base station
		part_start_page[0] = 2;
		part_end_page[0] = 3;
	
		//reserve all of the flash for a single log.
		part_start_page[1] = 4; 
		part_end_page[1] = 2040;
	
		part_start_page[2] = 2041;
		part_end_page[2] = 2047;
	}
	
	
	/*part_end_page[0] = 500;
	
	part_start_page[1] = 501;
	part_end_page[1] = 800;
	
	part_start_page[2] = 801;
	part_end_page[2] = 2047;*/
//************************************************//
	
	res = call InternalFlash.read((void*)IFLASH_LOG_VALID_ADDR, &valid, sizeof(valid));
	//res = FAIL;
	//valid = FALSE;
	if (valid == 0xAB && res == SUCCESS)
	{
		res &= call InternalFlash.read((void*)IFLASH_LOG_START_ADDR, (char*)the_log, sizeof(the_log));
		
		for (i=0; i < NUM_LOGS; i++)
		{
			if (the_log[i].end_offset != 0)
			{
				advanceEndPage(i);
			}
			the_log[i].read_page = the_log[i].start_page;
			the_log[i].read_offset = 0;
		}
		
	} else {
	
		for (i=0; i < NUM_LOGS; i++)
		{
			the_log[i].start_page = part_start_page[i];
			the_log[i].end_page = part_start_page[i];
			the_log[i].end_offset = 0;
			the_log[i].read_page = the_log[i].start_page;
			the_log[i].read_offset = 0;
		}
	}
	
	
	
    return SUCCESS;
  }


  command result_t StdControl.start() {
	
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }

  bool inLog(int logid)
  {
  	if (logid < 0 || logid >= NUM_LOGS)
	{	
		return FALSE;
	}
  
  	if (the_log[logid].start_page <= the_log[logid].end_page)
	{
		
		return ((the_log[logid].read_page >= the_log[logid].start_page) && (the_log[logid].read_page <= the_log[logid].end_page));
	} else {
		return (((the_log[logid].read_page >= the_log[logid].start_page) && (the_log[logid].read_page <= part_end_page[logid])) || ((the_log[logid].read_page <= the_log[logid].end_page) && (the_log[logid].read_page >= part_start_page[logid])));
	}
  }
  
  
  command result_t ObjLog.append[uint8_t id](int logid, uint8_t *data, uint8_t numbytes)
  {
  	result_t res;
	int16_t left;

	
	
  	if (numbytes > MAX_OBJ || logid < 0 || logid >= NUM_LOGS || numbytes == 0)
	{

		return FAIL;
	}
	
  	if (state != IDLE)
	{
			
		return FAIL;
	}
	state = APPEND;
	
	__ifid = id;
	__logid = logid;
	__numbytes = numbytes;
	
	//form chunk to append

	memcpy(__writebuf+1, data, numbytes);
	__writebuf[0] = numbytes;
	
	//is there room?
	left = MY_PAGE_SIZE - (the_log[__logid].end_offset);
	
	if (left < (__writebuf[0]+1))
	{
		advanceEndPage(__logid);
	}
	
	//position is now correct
	//if we are at the beginning of a page, then delete it before starting to write.
	if (the_log[__logid].end_offset == 0)
	{
		res = call PageEEPROM.erase(the_log[__logid].end_page, TOS_EEPROM_ERASE);
		if (res != SUCCESS)
		{
			//strange, but no harm done
			state = IDLE;
			return FAIL;
		}	
		return SUCCESS;
	}
	
	
	//plenty of space left
	res = call PageEEPROM.write(the_log[__logid].end_page, the_log[__logid].end_offset, __writebuf, __numbytes+1);
	if (res == SUCCESS)
	{
		
		return SUCCESS;
	}
	state = IDLE;
	return FAIL;
  }
  
  command uint16_t ObjLog.getNumPages[uint8_t id](int logid)
  {
  	if (logid < 0 || logid >= NUM_LOGS)
	{
		return 0xFFFF;
	}
  
  	if (the_log[logid].start_page <= the_log[logid].end_page)
	{
		return (the_log[logid].end_page - the_log[logid].start_page + 1);
	} else {
		return ((part_end_page[logid] - the_log[logid].start_page + 1) + (the_log[logid].end_page - part_start_page[logid]  + 1));
	}
  }
  
  command uint16_t ObjLog.getReadOffset[uint8_t id](int logid)
  {
  	if (logid < 0 || logid >= NUM_LOGS)
	{
		return 0xFFFF;
	}
	
	if (!inLog(logid))
	{
		return 0xFFFF;
	}
  	return the_log[logid].read_offset;
  }
  
  command uint16_t ObjLog.getReadPage[uint8_t id](int logid)
  {
  	if (logid < 0 || logid >= NUM_LOGS)
	{
		return 0xFFFF;
	}
	
	if (!inLog(logid))
	{
		return 0xFFFF;
	}
  
  	if (the_log[logid].start_page <= the_log[logid].read_page)
	{
		return (the_log[logid].read_page - the_log[logid].start_page);
	} else {
		return ((part_end_page[logid] - the_log[logid].start_page + 1) + (the_log[logid].end_page - part_start_page[logid]));
	}
  }
  
  command result_t ObjLog.deleteAll[uint8_t id](int logid)
  {
  	atomic {
  		if (logid < 0 || logid >= NUM_LOGS)
		{
			return FAIL;
		}
		
		if (state != IDLE)
		{
			return FAIL;
		}
		
		the_log[logid].start_page = part_start_page[logid];
		the_log[logid].end_page = part_start_page[logid];
		the_log[logid].end_offset = 0;
		the_log[logid].read_page = part_start_page[logid];
		the_log[logid].read_offset = 0;
	    writecount++;
		return SUCCESS;
	}
  }
  
  command result_t ObjLog.deletePage[uint8_t id](int logid)
  {
  	//uint16_t nextpage;
  
	if (logid < 0 || logid >= NUM_LOGS)
	{
		return FAIL;
	}
	
	if (state != IDLE)
	{
		return FAIL;
	}
	state = DELETE;  
	
	advanceStartPage(logid, TRUE);
	writecount++;
	
	state = IDLE;
	return SUCCESS;
  }
  
  command result_t ObjLog.seek[uint8_t id](int logid, uint16_t page)
  {
 
	
  	if (logid < 0 || logid >= NUM_LOGS)
	{
		return FAIL;
	}
	
	if (state != IDLE)
	{
		return FAIL;
	}
	state = SEEK;
	
  	if ((the_log[logid].start_page + page) <= the_log[logid].end_page)
	{
		the_log[logid].read_page = the_log[logid].start_page + page;
	} else {
		the_log[logid].read_page = part_start_page[logid] + ((the_log[logid].start_page + page) - part_end_page[logid]) - 1;
	}
	the_log[logid].read_offset = 0;
	dirty = TRUE;
	state = IDLE;
	return SUCCESS;
  }
  
  command result_t ObjLog.tryCommit[uint8_t id]()
	{
		if (writecount > 100)
		{
			post SaveLog();
		}
		return SUCCESS;
	}
  
  command result_t ObjLog.read[uint8_t id](int logid, bool *eol)
  {
  	result_t res;

	if (eol != NULL) *eol = FALSE;
  	if (logid < 0 || logid >= NUM_LOGS)
	{
		return FAIL;
	}
	
	if ((the_log[logid].read_page == the_log[logid].end_page &&
		the_log[logid].read_offset >= the_log[logid].end_offset) || !inLog(logid))
		{
			//at the end
			if (eol != NULL) *eol = TRUE;
			return FAIL;
		}
	
  	if (state != IDLE)
	{
		if (logid == 1){
	}
		return FAIL;
	}
	state = READ;
	
	__ifid = id;
	__logid = logid;
	
	res = call PageEEPROM.read(the_log[__logid].read_page, 0, __readbuf, MY_PAGE_SIZE);
	if (res == FAIL)
	{
		state = IDLE;
		return FAIL;
	}
	return SUCCESS;
  }
  
  
  void readFailed()
	{
		
		state = IDLE;
		signal ObjLog.readDone[__ifid](__logid, NULL, 0, FAIL);
	}
  
  event result_t PageEEPROM.readDone(result_t res)
    {
		uint16_t bytes;
		if (res == FAIL)
		{
			
			readFailed();
			return SUCCESS;
		}
		
		bytes = __readbuf[the_log[__logid].read_offset];
		if (bytes == 0 || bytes == 0xff || (the_log[__logid].read_offset+bytes+1) > MY_PAGE_SIZE)
		{
			//not a valid chunk
			the_log[__logid].read_page++;
			if (the_log[__logid].read_page >= part_end_page[__logid])
			{
				the_log[__logid].read_page = part_start_page[__logid];
			}
			the_log[__logid].read_offset = 0;
			dirty = TRUE;
			
			
			readFailed();
			
			return SUCCESS;
		}
		
		signal ObjLog.readDone[__ifid](__logid, __readbuf+the_log[__logid].read_offset+1, bytes, SUCCESS);
		
		if  ((the_log[__logid].read_offset+bytes+1 >= MY_PAGE_SIZE) || 
			(__readbuf[the_log[__logid].read_offset+bytes+1] == 0 || 			
			__readbuf[the_log[__logid].read_offset+bytes+1] == 0xff))
		{

		/* We have reached the last item in this page. */		
			if (the_log[__logid].read_page != the_log[__logid].end_page){
				/* Is it not the last item in the log */

				the_log[__logid].read_page++;
				if (the_log[__logid].read_page >= part_end_page[__logid])
				{
					the_log[__logid].read_page = part_start_page[__logid];
				}
				the_log[__logid].read_offset = 0;
			}
		
               else {
                            the_log[__logid].read_offset = the_log[__logid].end_offset;                
                     }
		} else {
			the_log[__logid].read_offset += bytes+1;
		}
		dirty = TRUE;		
		state = IDLE;	
		return SUCCESS;
	}

	void writeFailed()
	{
		state = IDLE;

		signal ObjLog.appendDone[__ifid](__logid, FAIL);
	}
	
	void writeSucceeded()
	{
		state = IDLE;
		writecount++;
		/*if (writecount > 50)
		{
			//post SaveLog();
		}*/
		signal ObjLog.appendDone[__ifid](__logid, SUCCESS);
	}
	
	
	
  	event result_t PageEEPROM.eraseDone(result_t res)
    {
		uint16_t offset;
		
		if (state != APPEND)
		{
			//stange! most certainly a bug.
			
			return SUCCESS;
		}
		
		if (res == FAIL)
		{
			writeFailed();
			return SUCCESS;
		}
		
		//clear old contents from the page
		//I don't think I should have to do this, but PageEEPROM isn't clearing the old contents,
		//resulting in end-of-page corruption.
		offset = __writebuf[0] + 1;
		memset(__writebuf + offset, 0xff, MY_PAGE_SIZE-offset);
		res = call PageEEPROM.write(the_log[__logid].end_page, the_log[__logid].end_offset, __writebuf,MY_PAGE_SIZE);
		if (res == FAIL)
		{
			writeFailed();
		}
        return (SUCCESS);
    }

    event result_t PageEEPROM.syncDone(result_t result)
    {
		writeSucceeded();
        
        return (SUCCESS);
    }

    event result_t PageEEPROM.computeCrcDone(result_t result, uint16_t crc)
    {
        return (SUCCESS);
    }
	
	task void flushPage()
	{
		result_t theres;
		theres = call PageEEPROM.syncAll();
		if (theres == FAIL)
		{
			writeFailed();
			
		}
	 	
	}
	
	event result_t PageEEPROM.writeDone(result_t res)
    {	
		
     	if (state != APPEND)
		{
			//very strange! should not ever happen
			return SUCCESS;
		}
		if (res == FAIL)
		{


			writeFailed();
			return SUCCESS;
		}
		
		the_log[__logid].end_offset += (__writebuf[0]+1);
		
		
		
		dirty = TRUE; //the_log needs to be saved to IFLASH
		
		post flushPage();
        return (SUCCESS);
    }

    event result_t PageEEPROM.flushDone(result_t res)
    {
	if (res == FAIL)
	{
		writeFailed();
		return SUCCESS;
	}

	writeSucceeded();
        return (SUCCESS);
    }
	
	default event result_t ObjLog.readDone[uint8_t id](int logid, uint8_t *buffer, uint16_t numbytes, result_t success)
	{
		return SUCCESS;
	}
	
	default event result_t ObjLog.appendDone[uint8_t id](int logid, result_t success)
	{
		return SUCCESS;
	}
}


