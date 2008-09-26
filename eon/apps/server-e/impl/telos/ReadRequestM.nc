includes structs;

module ReadRequestM
{
  provides
  {
    interface StdControl;
    interface IReadRequest;
  }
  uses
	{
		interface Leds;
	}
}
implementation
{
#include "fluxconst.h"

	bool busy = FALSE;
	uint16_t connid;
	ReadRequest_in** invar;
	ReadRequest_out** outvar;
	int i;

  command result_t StdControl.init ()
  {
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

  command bool IReadRequest.ready ()
  {
    return !busy;
  }


	int8_t gettype()
	{
		//find extension
		int idx=0;
		uint8_t *url = (*outvar)->request.url;
		

		while (url[idx] != 0 && url[idx] != '.') 
		{
			idx++;
		}			
		
		if (url[idx] == 0) 
		{
			
			return 0;
		}
		
		if (strcmp(url+idx, ".txt") == 0) return 1;
		if (strcmp(url+idx, ".jpg") == 0) return 2;
		if (strcmp(url+idx, ".mp3") == 0) return 3;
		if (strcmp(url+idx, ".mpg") == 0) return 4;
		return 0;
	}

  	task void readTask()
	{
		(*outvar)->type = gettype();
		
		signal IReadRequest.nodeDone (invar, outvar, ERR_OK);
		busy = FALSE;
		return;
	}
	
	
	
  command result_t IReadRequest.nodeCall (ReadRequest_in ** in,
					  ReadRequest_out ** out)
  {
	busy = TRUE;
	invar = in;
	outvar = out;
	
	memcpy(&((*outvar)->request), &((*invar)->request), sizeof(RequestMsg));
	//call Leds.redToggle();
	post readTask();		

    return SUCCESS;
  }
	
}
