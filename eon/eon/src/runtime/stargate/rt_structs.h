#ifndef RT_STRUCTS_H_INCLUDED
#define RT_STRUCTS_H_INCLUDED

#include <stdint.h>
#include "sfaccess/tinystream.h"

typedef char* request_t;
typedef int8_t result_t;
//typedef uint8_t bool;

#define TRUE 1
#define FALSE 0

typedef struct rt_data 
{
  uint16_t sessionID;
  uint32_t starttime;
  uint16_t weight;
  uint8_t minstate;
  bool wake;
  uint32_t elapsed_us;
} rt_data;

typedef struct GenericNode
{
  rt_data _pdata;
} GenericNode;

#endif
