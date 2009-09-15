#ifndef DATA_PLANE_H
#define DATA_PLANE_H



#include <AM.h>
#include <message.h>


enum {
#if PLATFORM_MICAZ || PLATFORM_TELOSA || PLATFORM_TELOSB || PLATFORM_TMOTE
  FORWARD_PACKET_TIME = 4,
#else
  FORWARD_PACKET_TIME = 32,
#endif
};

enum {
  SENDDONE_FAIL_OFFSET      =                       512,
  SENDDONE_NOACK_OFFSET     = FORWARD_PACKET_TIME  << 2,
  SENDDONE_OK_OFFSET        = FORWARD_PACKET_TIME  << 2,
  LOOPY_OFFSET              = FORWARD_PACKET_TIME  << 4,
  SENDDONE_FAIL_WINDOW      = SENDDONE_FAIL_OFFSET  - 1,
  LOOPY_WINDOW              = LOOPY_OFFSET          - 1,
  SENDDONE_NOACK_WINDOW     = SENDDONE_NOACK_OFFSET - 1,
  SENDDONE_OK_WINDOW        = SENDDONE_OK_OFFSET    - 1,
  CONGESTED_WAIT_OFFSET     = FORWARD_PACKET_TIME  << 2,
  CONGESTED_WAIT_WINDOW     = CONGESTED_WAIT_OFFSET - 1,
};




typedef nx_struct {
  nx_uint8_t control;
  nx_am_addr_t origin;
  nx_uint8_t seqno;
  nx_uint8_t collectid;
  nx_uint16_t gradient;
} network_header_t;


typedef struct {
  message_t *msg;
  uint8_t client;
  uint8_t retries;
} fe_queue_entry_t;

#endif
