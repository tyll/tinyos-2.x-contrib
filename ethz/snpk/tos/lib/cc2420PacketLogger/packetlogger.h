#ifndef PACKETLOGGER_H
#define PACKETLOGGER_H

typedef nx_struct  {
  nx_uint16_t logId;
  nx_uint8_t type;
  nx_uint32_t time;
  nx_uint16_t count;
  nx_am_addr_t source;
  nx_uint8_t dsn;
  nx_bool ack;
} packet_logger_event_t;

enum {
	PL_TYPE_WAKEUP=1,
	PL_TYPE_RX=2,
	PL_TYPE_TX=3,
};
#endif

