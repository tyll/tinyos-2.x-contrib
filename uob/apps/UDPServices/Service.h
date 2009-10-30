#ifndef _SERVICE_H
#define _SERVICE_H

enum {
  MAX_NAME_LENGTH = 20,
  MAX_SNAME_LENGTH = 10,
  MAX_DATA_LENGTH = 16,
};

/* enum{ */
/*   INVALID_SERVICE_TYPE = 0, */
/*   SOURCE_SERVICE_TYPE = 1, */
/*   SINK_SERVICE_TYPE = 2, */
/*   PROCESSING_SERVICE_TYPE = 3, */
/* }; */

/* nx_struct service_t { */
/*   nx_uint16_t type; */
/*   nx_uint8_t  name[MAX_NAME_LENGTH]; */
/* }; */

enum {
  TYPE_SRV  = 0x0021,
  TYPE_AAAA = 0x001c,

  FLAG_RESPONSE            = 0x8000,
  FLAG_STANDARD_QUERY      = 0x0000, // more details
  FLAG_AUTHORATIVE         = 0x0400,
  FLAG_TRUNCATED           = 0x0200,
  FLAG_RECURSION_DESIRED   = 0x0100,
  FLAG_RECURSION_AVAILABLE = 0x0080,
  FLAG_RESERVED            = 0x0040,
  FLAG_AUTHENTICATED       = 0x0020,
  FLAG_ERROR               = 0x0010, // more details

  CLASS_IN = 0x0001,
  CACHE_FLUSH_TRUE = 0x8000,
};


typedef nx_struct {
  nx_uint8_t  name[MAX_NAME_LENGTH];
  nx_uint16_t type;
  nx_uint16_t class;
  nx_uint32_t ttl;
  nx_uint16_t data_length;
  nx_uint16_t prio;
  nx_uint16_t weight;
  nx_uint16_t port;
  nx_uint8_t  target[MAX_SNAME_LENGTH];
} mdns_srv_answer_t;

typedef nx_struct {
  nx_uint8_t  name[MAX_SNAME_LENGTH];
  nx_uint16_t type;
  nx_uint16_t class;
  nx_uint32_t ttl;
  nx_uint16_t data_length;
  nx_uint8_t  addr[MAX_DATA_LENGTH];
} mdns_aaaa_answer_t;

nx_struct mdns_service_t {
  nx_uint16_t transaction_id;
  nx_uint16_t flags;
  nx_uint16_t questions;
  nx_uint16_t answer_rr;
  nx_uint16_t auth_rr;
  nx_uint16_t additional_rr;

  mdns_srv_answer_t srv_answer;
  mdns_aaaa_answer_t a4_answer;
} ;


#endif

