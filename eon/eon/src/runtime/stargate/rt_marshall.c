


#include "rt_marshall.h"
#include "rt_structs.h"
#include <stdint.h>
#include "sfaccess/tinystream.h"

int unmarshall_start(int cid, uint16_t *nodeid)
{
	uint8_t dtype;
	uint8_t data[2];
	int result;
	
	dbg(APP,"unmarsh,start:");
	result = tinystream_read(cid, &dtype, 1);
	if (result)
	{
		dbg(APP,"read_error getting type\n");
		return -1;
	}
	if (dtype != TYPE_START)
	{
		dbg(APP,"type_error\n");
		return -1;
	}
	result = tinystream_read(cid, data, 2);
	if (result)
	{
		dbg(APP,"read_error getting data\n");
		return -1;
	}
	*nodeid = ((uint16_t)data[0] << 8) + data[1];
	dbg(APP,"nodeid = %i\n",*nodeid);
	return 0;
}

int unmarshall_end(int cid, uint16_t *nodeid)
{
	uint8_t dtype;
	uint8_t data[2];
	int result;
	
	result = tinystream_read(cid, &dtype, 1);
	if (result)
	{
		return -1;
	}
	if (dtype != TYPE_END)
	{
		return -1;
	}
	result = tinystream_read(cid, data, 2);
	if (result)
	{
		return -1;
	}
	*nodeid = ((uint16_t)data[0] << 8) + data[1];
	return 0;
}

int unmarshall_session(int cid, rt_data *_pdata)
{
	int result;
	dbg(APP,"umarsh_session:\n");
	result = unmarshall_uint16_t(cid, &_pdata->sessionID);
	if (result) return -1;
	dbg(APP,"id=%i\n",_pdata->sessionID);
	result = unmarshall_uint32_t(cid, &_pdata->starttime);
	if (result) return -1;
	dbg(APP,"t=%i\n",_pdata->starttime);
	result = unmarshall_uint16_t(cid, &_pdata->weight);
	if (result) return -1;
	dbg(APP,"w=%i\n",_pdata->weight);
	result = unmarshall_uint8_t(cid, &_pdata->minstate);
	if (result) return -1;
	dbg(APP,"ms=%i\n",_pdata->minstate);
	result = unmarshall_bool(cid, &_pdata->wake);
	if (result) return -1;
	dbg(APP,"wake=%i\ndone.",_pdata->wake);
	
	return 0;
}

int unmarshall_uint8_t(int cid, uint8_t *data)
{
	uint8_t dtype;
	int result;
	
	result = tinystream_read(cid, &dtype, 1);
	if (result)
	{
		return -1;
	}
	if (dtype != TYPE_UINT8)
	{
		return -1;
	}
	result = tinystream_read(cid, data, 1);
	if (result)
	{
		return -1;
	}
	return 0;
}

int unmarshall_int8_t(int cid, int8_t *data)
{
	uint8_t dtype;
	int result;
	
	result = tinystream_read(cid, &dtype, 1);
	if (result)
	{
		return -1;
	}
	if (dtype != TYPE_INT8)
	{
		return -1;
	}
	result = tinystream_read(cid, data, 1);
	if (result)
	{
		return -1;
	}
	return 0;
}

int unmarshall_uint16_t(int cid, uint16_t *data)
{
	uint8_t dtype;
	uint8_t buf[2];
	int result;
	
	result = tinystream_read(cid, &dtype, 1);
	if (result)
	{
		return -1;
	}
	if (dtype != TYPE_UINT16)
	{
		return -1;
	}
	result = tinystream_read(cid, buf, 2);
	if (result)
	{
		return -1;
	}
	*data = ((uint16_t)buf[0] << 8) + buf[1];
	return 0;
}

int unmarshall_int16_t(int cid, int16_t *data)
{
	uint8_t dtype;
	uint8_t buf[2];
	int result;
	
	result = tinystream_read(cid, &dtype, 1);
	if (result)
	{
		return -1;
	}
	if (dtype != TYPE_INT16)
	{
		return -1;
	}
	result = tinystream_read(cid, buf, 2);
	if (result)
	{
		return -1;
	}
	*data = ((int16_t)buf[0] << 8) + buf[1];
	return 0;
}

int unmarshall_uint32_t(int cid, uint32_t *data)
{
	uint8_t dtype;
	uint8_t buf[4];
	int result;
	
	result = tinystream_read(cid, &dtype, 1);
	if (result)
	{
		return -1;
	}
	if (dtype != TYPE_UINT32)
	{
		return -1;
	}
	result = tinystream_read(cid, buf, 4);
	if (result)
	{
		return -1;
	}
	*data = ((uint32_t)buf[0] << 24) + ((uint32_t)buf[1] << 16) + 
			((uint32_t)buf[2] << 8) + buf[3];
	return 0;
}

int unmarshall_int32_t(int cid, int32_t *data)
{
	uint8_t dtype;
	uint8_t buf[4];
	int result;
	
	result = tinystream_read(cid, &dtype, 1);
	if (result)
	{
		return -1;
	}
	if (dtype != TYPE_INT32)
	{
		return -1;
	}
	result = tinystream_read(cid, buf, 4);
	if (result)
	{
		return -1;
	}
	*data = ((int32_t)buf[0] << 24) + ((int32_t)buf[1] << 16) + 
			((int32_t)buf[2] << 8) + buf[3];
	return 0;
}

int unmarshall_bool(int cid, bool *data)
{
	return unmarshall_int8_t(cid, data);	
}

int unmarshall_request_t(int cid, request_t* data)
{
	return MARSH_OK;
}

//************************************************
//MARSHALLING FUNCS
//************************************************/

int marshall_start(int cid, uint16_t nodeid)
{
	uint8_t type = TYPE_START;
	uint8_t buf[2];
	int result;
	result = tinystream_write(cid, &type, 1);
	if (result) return -1;
	buf[0] = nodeid >> 8;
	buf[1] = nodeid && 0xFF;
	result = tinystream_write(cid, buf, 2);
	if (result) return -1;
  	return MARSH_OK;
}

int marshall_session(int cid, rt_data _pdata)
{
  return MARSH_OK;
}

int marshall_int8_t(int cid, int8_t data)
{
  	uint8_t type = TYPE_INT8;
	int8_t buf;
	int result;
	result = tinystream_write(cid, &type, 1);
	if (result) return -1;
	buf = data;
	result = tinystream_write(cid, &buf, 1);
	if (result) return -1;
  	return MARSH_OK;
}


int marshall_uint8_t(int cid, uint8_t data)
{
	uint8_t type = TYPE_UINT8;
	uint8_t buf;
	int result;
	result = tinystream_write(cid, &type, 1);
	if (result) return -1;
	buf = data;
	result = tinystream_write(cid, &buf, 1);
	if (result) return -1;
  	return MARSH_OK;
  
}

int marshall_int16_t(int cid, int16_t data)
{
  	uint8_t type = TYPE_INT16;
	uint8_t buf[2];
	int result;
	result = tinystream_write(cid, &type, 1);
	if (result) return -1;
	buf[0] = data >> 8;
	buf[1] = data && 0xFF;
	result = tinystream_write(cid, buf, 2);
	if (result) return -1;
  	return MARSH_OK;
}


int marshall_uint16_t(int cid, uint16_t data)
{
 	uint8_t type = TYPE_UINT16;
	uint8_t buf[2];
	int result;
	result = tinystream_write(cid, &type, 1);
	if (result) return -1;
	buf[0] = data >> 8;
	buf[1] = data && 0xFF;
	result = tinystream_write(cid, buf, 2);
	if (result) return -1;
  	return MARSH_OK;
}

int marshall_int32_t(int cid, int32_t data)
{
  	uint8_t type = TYPE_INT32;
	uint8_t buf[4];
	int result;
	result = tinystream_write(cid, &type, 1);
	if (result) return -1;
	buf[0] = (data >> 24) && 0xFF;
	buf[1] = (data >> 16) && 0xFF;
	buf[2] = (data >> 8) && 0xFF;
	buf[3] = data && 0xFF;
	result = tinystream_write(cid, buf, 4);
	if (result) return -1;
  	return MARSH_OK;
}

int marshall_uint32_t(int cid, uint32_t data)
{
  	uint8_t type = TYPE_UINT32;
	uint8_t buf[4];
	int result;
	result = tinystream_write(cid, &type, 1);
	if (result) return -1;
	buf[0] = (data >> 24) && 0xFF;
	buf[1] = (data >> 16) && 0xFF;
	buf[2] = (data >> 8) && 0xFF;
	buf[3] = data && 0xFF;
	result = tinystream_write(cid, buf, 4);
	if (result) return -1;
  	return MARSH_OK;
}


int marshall_char(int cid, char data)
{
  return marshall_int8_t(cid,(int8_t)data);
}

int marshall_bool(int cid, bool data)
{
  return marshall_int8_t(cid, (int8_t)data);
}

int marshall_request_t(int cid, request_t data)
{
  return MARSH_OK;
}

