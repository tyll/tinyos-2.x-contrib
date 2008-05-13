#ifndef SNIFF802154_H
#define SNIFF802154_H

enum {
  AM_CONTROL_PKT_T = 215,	/* AM id for Serial packet containing control information as payload (i.e. #channel) */
};

typedef nx_struct control_pkt_t {
  nx_uint8_t channel;  /* which channel to listen on */
} control_pkt_t;
#endif
