#ifndef FLUXMARSHAL_H_INCLUDED
#define FLUXMARSHAL_H_INCLUDED

#include "../nodes.h"
#include "../usermarshal.h"

#define TYPE_START  0
#define TYPE_END    1
#define TYPE_UINT8  2
#define TYPE_UINT16 3
#define TYPE_UINT32 4
#define TYPE_INT8   5
#define TYPE_INT16  6
#define TYPE_INT32  7

#define MARSH_OK   0
#define MARSH_ERR  1
#define MARSH_FULL 2
#define MARSH_WAIT 3
#define MARSH_TYPE 4
#define MARSH_DONE 5

uint8_t encode_int32_t (uint16_t connid, int32_t data);
uint8_t encode_uint32_t (uint16_t connid, uint32_t data);
uint8_t encode_int16_t (uint16_t connid, int16_t data);
uint8_t encode_uint16_t (uint16_t connid, uint16_t data);
uint8_t encode_int8_t (uint16_t connid, int8_t data);
uint8_t encode_uint8_t (uint16_t connid, uint8_t data);
uint8_t encode_bool (uint16_t connid, bool data);

/******************************
 *Encode functions

**********************************/


uint8_t
enc_return (result_t result, uint16_t bytes)
{
  if (result == FAIL)
    {
      return MARSH_ERR;
    }

  if (bytes == 0)
    {
      return MARSH_FULL;
    }
  return MARSH_OK;
}


uint8_t
encode_start (uint16_t connid, uint16_t nodeid)
{

  uint8_t buffer[3];
  uint16_t bytes;
  result_t result;

  if (nodeid >= NUMNODES)
    {
    	
      return MARSH_ERR;
    }

  buffer[0] = TYPE_START;
  buffer[1] = nodeid >> 8;
  buffer[2] = nodeid & 0xFF;

  result =
    call RemoteWrite.write (connid, buffer, sizeof (nodeid) + 1, &bytes);
	
  return enc_return (result, bytes);

}

uint8_t
encode_session (uint16_t connid, rt_data _pdata)
{
  result_t result;

  result = encode_uint16_t (connid, _pdata.sessionID);
  if (result != MARSH_OK)
    return result;
  result = encode_uint32_t (connid, _pdata.starttime);
  if (result != MARSH_OK)
    return result;
  result = encode_uint16_t (connid, _pdata.weight);
  if (result != MARSH_OK)
    return result;
  result = encode_uint8_t (connid, _pdata.minstate);
  if (result != MARSH_OK)
    return result;
  result = encode_bool (connid, _pdata.wake);
  if (result != MARSH_OK)
    return result;
  return MARSH_OK;
}


uint8_t
encode_end (uint16_t connid, uint16_t nodeid)
{

  uint8_t buffer[3];
  uint16_t bytes;
  result_t result;

  if (nodeid >= NUMNODES)
    {
      return MARSH_ERR;
    }

  buffer[0] = TYPE_END;
  buffer[1] = nodeid >> 8;
  buffer[2] = nodeid & 0xFF;

  result = call RemoteWrite.write (connid, buffer, sizeof (buffer), &bytes);

  return enc_return (result, bytes);

}


uint8_t
encode_uint8_t (uint16_t connid, uint8_t data)
{

  uint8_t buffer[2];
  uint16_t bytes;
  result_t result;


  buffer[0] = TYPE_UINT8;
  buffer[1] = data;

  result = call RemoteWrite.write (connid, buffer, sizeof (buffer), &bytes);

  return enc_return (result, bytes);

}


uint8_t
encode_uint16_t (uint16_t connid, uint16_t data)
{

  uint8_t buffer[3];
  uint16_t bytes;
  result_t result;


  buffer[0] = TYPE_UINT16;
  buffer[1] = data >> 8;
  buffer[2] = data & 0xFF;

  result = call RemoteWrite.write (connid, buffer, sizeof (buffer), &bytes);

  return enc_return (result, bytes);

}


uint8_t
encode_uint32_t (uint16_t connid, uint32_t data)
{

  uint8_t buffer[5];
  uint16_t bytes;
  result_t result;


  buffer[0] = TYPE_UINT32;
  buffer[1] = (data >> 24) & 0xFF;
  buffer[2] = (data >> 16) & 0xFF;
  buffer[3] = (data >> 8) & 0xFF;
  buffer[4] = data & 0xFF;


  result = call RemoteWrite.write (connid, buffer, sizeof (buffer), &bytes);

  return enc_return (result, bytes);

}

uint8_t
encode_int8_t (uint16_t connid, int8_t data)
{

  uint8_t buffer[2];
  uint16_t bytes;
  result_t result;


  buffer[0] = TYPE_INT8;
  buffer[1] = data;

  result = call RemoteWrite.write (connid, buffer, sizeof (buffer), &bytes);

  return enc_return (result, bytes);

}


uint8_t
encode_int16_t (uint16_t connid, int16_t data)
{

  uint8_t buffer[3];
  uint16_t bytes;
  result_t result;


  buffer[0] = TYPE_INT16;
  buffer[1] = data >> 8;
  buffer[2] = data & 0xFF;

  result = call RemoteWrite.write (connid, buffer, sizeof (buffer), &bytes);

  return enc_return (result, bytes);

}


uint8_t
encode_int32_t (uint16_t connid, int32_t data)
{

  uint8_t buffer[5];
  uint16_t bytes;
  result_t result;


  buffer[0] = TYPE_INT32;
  buffer[1] = (data >> 24) & 0xFF;
  buffer[2] = (data >> 16) & 0xFF;
  buffer[3] = (data >> 8) & 0xFF;
  buffer[4] = data & 0xFF;


  result = call RemoteWrite.write (connid, buffer, sizeof (buffer), &bytes);

  return enc_return (result, bytes);

}

uint8_t
encode_int (uint16_t connid, int data)
{
  return encode_int16_t (connid, (int16_t) data);
}


uint8_t
encode_char (uint16_t connid, char data)
{
  return encode_int8_t (connid, (int8_t) data);
}

uint8_t
encode_bool (uint16_t connid, bool data)
{
  return encode_int8_t (connid, (bool) data);
}

uint8_t
encode_request_t (uint16_t connid, request_t data)
{
  return MARSH_OK;
}

/***************************
Decode
***************************/

uint8_t
decode_start (uint16_t connid, uint16_t * nodeid)
{

  uint8_t buffer[3];
  uint16_t bytes;
  result_t result;


  result = call RemoteRead.read (connid, buffer, sizeof (buffer), &bytes);

  if (result == FAIL)
    return MARSH_ERR;
  if (bytes == 0)
    return MARSH_WAIT;
  if (buffer[0] != TYPE_START)
    return MARSH_TYPE;

  *nodeid = (buffer[1] << 8) | buffer[2];

  return MARSH_OK;

}


uint8_t
decode_uint8_t (uint16_t connid, uint8_t * data)
{

  uint8_t buffer[2];
  uint16_t bytes;
  result_t result;


  result = call RemoteRead.read (connid, buffer, sizeof (buffer), &bytes);

  if (result == FAIL)
    return MARSH_ERR;
  if (bytes == 0)
    return MARSH_WAIT;
  if (buffer[0] != TYPE_UINT8)
    return MARSH_TYPE;

  *data = buffer[1];

  return MARSH_OK;

}


uint8_t
decode_uint16_t (uint16_t connid, uint16_t * data)
{

  uint8_t buffer[3];
  uint16_t bytes;
  result_t result;


  result = call RemoteRead.read (connid, buffer, sizeof (buffer), &bytes);

  if (result == FAIL)
    return MARSH_ERR;
  if (bytes == 0)
    return MARSH_WAIT;
  if (buffer[0] != TYPE_UINT16)
    return MARSH_TYPE;

  *data = (buffer[1] << 8) | buffer[2];

  return MARSH_OK;

}


uint8_t
decode_uint32_t (uint16_t connid, uint32_t * data)
{

  uint8_t buffer[5];
  uint16_t bytes;
  result_t result;

  uint32_t values[4];

  result = call RemoteRead.read (connid, buffer, sizeof (buffer), &bytes);

  if (result == FAIL)
    return MARSH_ERR;
  if (bytes == 0)
    return MARSH_WAIT;
  if (buffer[0] != TYPE_UINT32)
    return MARSH_TYPE;

  values[0] = buffer[1];
  values[1] = buffer[2];
  values[2] = buffer[3];
  values[3] = buffer[4];

  *data =
    (values[1] << 24) | (values[2] << 16) | (values[3] << 8) | values[4];

  return MARSH_OK;

}


#endif
