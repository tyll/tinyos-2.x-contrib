#ifndef RT_STRUCTS_H_INCLUDED
#define RT_STRUCTS_H_INCLUDED

#include <stdint.h>

typedef int8_t result_t;


#define TRUE 1
#define FALSE 0

typedef struct rt_data 
{
  uint16_t sessionID;
  //uint32_t starttime;
  uint16_t weight;
  //uint8_t minstate;
  //uint32_t elapsed_us;
} rt_data;

typedef struct GenericNode
{
  rt_data _pdata;
} GenericNode;

#endif
