#ifndef USERMARSHAL_H_INCLUDED
#define USERMARSHAL_H_INCLUDED



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

//prototypes for built in types
uint8_t encode_int32_t (uint16_t connid, int32_t data);
uint8_t encode_uint32_t (uint16_t connid, uint32_t data);
uint8_t encode_int16_t (uint16_t connid, int16_t data);
uint8_t encode_uint16_t (uint16_t connid, uint16_t data);
uint8_t encode_int8_t (uint16_t connid, int8_t data);
uint8_t encode_uint8_t (uint16_t connid, uint8_t data);
uint8_t encode_bool (uint16_t connid, bool data);
uint8_t encode_RequestMsg (uint16_t connid, RequestMsg data);

/******************************
 *Encode functions for user defined types

**********************************/


uint8_t
encode_RequestMsg (uint16_t connid, RequestMsg msg)
{
  result_t result;
  int i=0;
  
  result = encode_uint16_t (connid, msg.src);
  if (result != MARSH_OK)
    return result;
  result = encode_uint16_t (connid, msg.suid);
  if (result != MARSH_OK)
    return result;
  for (i = 0; i < URL_LENGTH; i++)
	{
		result = encode_uint8_t (connid, msg.url[i]);
		if (result != MARSH_OK)
    		return result;
	}  
  
  return MARSH_OK;
}



#endif
