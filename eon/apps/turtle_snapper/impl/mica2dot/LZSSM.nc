includes structs;

module LZSSM
{
  provides
  {
    interface StdControl;
    interface ILZSS;
  }
}
implementation
{


uint8_t outbuf[DATA_MSG_DATA_LEN];
int num_bytes;
bool ended;
uint8_t *__indata;
int __length,__i;


  command result_t StdControl.init ()
  {
  	num_bytes = 0;
	ended = FALSE;
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  	command result_t ILZSS.compress_start()
 	{
  		num_bytes = 0;
		ended = FALSE;
		return SUCCESS;
  	}
    
	task void pushTask()
	{
		
		while (__i < __length)
		{
			outbuf[num_bytes] = __indata[__i];
			num_bytes++;
			__i++;
			if (num_bytes == DATA_MSG_DATA_LEN)
			{
				signal ILZSS.compressed(outbuf, num_bytes);
				return;
			}
			
		}
		signal ILZSS.pushDone(SUCCESS);
		
	}
	
    command result_t ILZSS.push(void *data, int len)
	{
		if (ended == TRUE)
		{
			return FAIL;
		}
		__indata = (uint8_t*)data;
		__length = len;
		__i = 0;
		post pushTask();
		return SUCCESS;
	}
	
	command result_t ILZSS.compressed_done()
	{
		if (!ended)
		{
			num_bytes = 0;
			post pushTask();
		}
		return SUCCESS;
	}

    command result_t ILZSS.compress_end()
	{
		//m_bytes = 0;
		ended = TRUE;
		if (num_bytes != 0)
		{
			signal ILZSS.compressed(outbuf, num_bytes);
			num_bytes = 0;
		}
		return SUCCESS;
	}
  
	default event void ILZSS.pushDone(result_t res)
	{
	}
	
    default event void ILZSS.compressed(void *data, int len)
	{
	}
}

