#ifndef MC13192_MSG_H
#define MC13192_MSG_H

#include "AM.h"

typedef nx_struct MC13192Header {
  nx_am_addr_t dest;
  nx_am_addr_t source;
  nx_uint8_t length;
  nx_am_group_t group;
  nx_am_id_t type;
} mc13192_header_t;

typedef nx_struct MC13192Footer {
  nx_uint8_t foo; // We always send an uneven number of bytes
} mc13192_footer_t;

typedef nx_struct MC13192Metadata { 
  nx_uint8_t lqi;
  nx_uint8_t receivedBytes;
} mc13192_metadata_t;

#endif