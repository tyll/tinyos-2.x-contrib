#include "userstructs.h"

module SCache
{
  provides
  {
    interface StdControl;
    interface ICache;
  }
}
implementation
{

#define NUMMSG	50
	StatusMsg_t messages[NUMMSG];
	bool valid[NUMMSG];
	int rdcount, wrcount;
	int status;

	command result_t StdControl.init()
	{
		int i;
		rdcount = 0;
		wrcount = 0;
		status = 0;
		for (i=0; i < NUMMSG; i++)
		{
			valid[i] = FALSE;
		}
		return SUCCESS;
	}
	
	command result_t StdControl.start()
	{
		return SUCCESS;
	}
	
	command result_t StdControl.stop()
	{
	
		return SUCCESS;
	}
	
	command result_t ICache.get(StatusMsg_t *msg)
	{
		if (valid[rdcount]== TRUE)
		{
			memcpy(msg, &messages[rdcount], sizeof(StatusMsg_t));
			valid[rdcount] = FALSE;
			rdcount = (rdcount+1) % NUMMSG;
			return SUCCESS;
		} else {
			return FAIL;
		}
	}
	
	command result_t ICache.put(StatusMsg_t *msg)
	{
		if (valid[wrcount]== FALSE)
		{
			memcpy(&messages[wrcount], msg, sizeof(StatusMsg_t));
			valid[wrcount] = TRUE;
			wrcount = (wrcount+1) % NUMMSG;
			return SUCCESS;
		} else {
			return FAIL;
		}
	}
	
	command result_t ICache.setStatus(int s)
	{
		if (s >= 0 && s <= 0xFF)
		{
			status = s;
			return SUCCESS;
		} else {
			return FAIL;
		}
	}
	
	command int ICache.getStatus()
	{
		return status;
	}

}
