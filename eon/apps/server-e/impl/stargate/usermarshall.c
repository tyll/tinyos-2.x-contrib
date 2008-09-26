


#include "usermarshall.h"
#include "rt_structs.h"
#include <stdint.h>


int unmarshall_RequestMsg(int cid, RequestMsg *data)
{
	int result;
	int i=0;
	
	dbg(APP,"umarsh_RequestMsg:\n");
	result = unmarshall_uint16_t(cid, &data->src);
	if (result) return -1;
	dbg(APP,"src=%i\n",data->src);
	result = unmarshall_uint16_t(cid, &data->suid);
	if (result) return -1;
	dbg(APP,"suid=%i\n",data->suid);
	
	for (i=0; i < URL_LENGTH; i++)
	{
		result = unmarshall_uint8_t(cid, &data->url[i]);
		if (result) return -1;
		dbg(APP,"%X ",data->url[i]);	
	}
	
	
	return 0;
}


//************************************************
//MARSHALLING FUNCS
//************************************************/

