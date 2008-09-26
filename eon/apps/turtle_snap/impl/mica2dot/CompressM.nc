includes structs;


module CompressM
{
  provides
  	{
    	interface StdControl;
    	interface ICompress;
	}
	uses
	{
		interface StreamExport;
  	}
}
implementation
{
#include "fluxconst.h"

//stream_t newstream;
uint8_t *_outdata;
datalen_t _outlength;
GpsData_t _indata;
datalen_t _inlength;
Compress_in **node_in;
Compress_out **node_out;
bool __done;

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

  command bool ICompress.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  
  
  command result_t ICompress.nodeCall (Compress_in ** in, Compress_out ** out)
  {
  		result_t res;
		
		node_in = in;
		node_out = out;
		
		
		res = call StreamExport.export(&((*node_out)->stream));
		//can't fail so...
		
		if (res == FAIL)
		{
			signal ICompress.nodeDone (in, out, ERR_USR);
		} else {
			signal ICompress.nodeDone (in, out, ERR_OK);
		}
    return SUCCESS;
  }
}
