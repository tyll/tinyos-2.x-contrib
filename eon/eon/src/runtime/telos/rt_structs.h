#ifndef RT_STRUCTS_H_INCLUDED
#define RT_STRUCTS_H_INCLUDED

typedef struct rt_data
{
  uint16_t sessionID;
  uint32_t starttime;
  uint16_t weight;
  uint8_t minstate;
  uint8_t wake;
  uint32_t elapsed_us;
} rt_data;

typedef struct GenericNode
{
  rt_data _pdata;
} GenericNode;

typedef uint8_t request_t[50];
#endif
