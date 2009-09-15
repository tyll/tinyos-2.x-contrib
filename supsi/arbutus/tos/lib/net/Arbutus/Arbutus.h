

#ifndef Arbutus_H
#define Arbutus_H

#include <Collection.h>
#include <AM.h>

#define UQ_ARBUTUS_CLIENT "ArbutusSenderC.CollectId"

enum {
    // AM types:
    AM_ARBUTUS_DATA    = 23,
    AM_ARBUTUS_ROUTING = 24,
    AM_ARBUTUS_DEBUG   = 25,
        OLD_FEEDBACK = 8,
                ROUTE_INVALID    = 0x7f,
    METRIC_INVALID = 0xFFFF,
      };

typedef nx_struct {
  nx_uint16_t         etx;
  nx_am_addr_t        origin;
  nx_uint16_t          originSeqNo;
  nx_uint16_t totalOwnTraffic;
  nx_uint16_t totalRelayedTraffic;
  nx_uint8_t hopcount;
  nx_collection_id_t  type;
  nx_uint8_t          data[0];
} Arbutus_data_header_t;

typedef nx_struct {
  nx_am_addr_t sender;
  nx_am_addr_t parent;
  nx_am_addr_t formerParent;
  nx_uint16_t advertisedHopcount;
  nx_uint16_t hopcount;
  nx_uint8_t rssBottleneck;
  nx_uint8_t lqiBottleneck;
  nx_uint16_t loadBottleneck;
  nx_uint16_t rate;
  nx_uint8_t linkRSS;
  nx_uint8_t linkLQI;
  nx_uint16_t localLoad;
  nx_uint16_t controlSeqNo;
  nx_uint16_t mtx;
} Arbutus_routing_frame_t;





#endif
