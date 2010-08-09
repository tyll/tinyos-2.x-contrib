#ifndef TEST_PACKET_TIMESYNC_H
#define TEST_PACKET_TIMESYNC_H

typedef nx_struct ping_msg {
  nx_uint16_t pinger;
  nx_uint32_t ping_counter;
  nx_uint32_t ping_event_time;
  nx_uint32_t prev_ping_counter;
  nx_uint8_t  prev_ping_tx_timestamp_is_valid;
  nx_uint32_t prev_ping_tx_timestamp;
  nx_uint32_t mac_timestamp;
} ping_msg_t;

typedef nx_struct pong_msg {
  nx_uint16_t ponger;
  nx_uint16_t pinger;
  nx_uint32_t ping_counter;
  nx_uint32_t ping_event_time;
  nx_uint8_t  ping_rx_timestamp_is_valid;
  nx_uint8_t  ping_event_time_is_valid;
  nx_uint32_t ping_rx_timestamp;
  nx_uint32_t mac_timestamp;  
} pong_msg_t;

enum {
  AM_PING_MSG = 16,
  AM_PONG_MSG = 17,
};

#endif
